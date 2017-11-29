import pymongo, requests,shapefile, numpy, time

start = time.time()

params = {
  'dbport' : open('conf/dbport').readlines()[0].replace("\n",""),
  'dbauth' : open('conf/dbauth').readlines()[0].replace("\n",""),
  'dbname' : open('conf/dbname').readlines()[0].replace("\n","")
}

mongo = pymongo.MongoClient('mongodb://'+params['dbauth']+'@127.0.0.1:'+params['dbport'])
database = mongo[params['dbname']]

resolution = 10
buff = 5
geoshape = shapefile.Reader('gis/paris.shp').shapes()
latmin=1000;latmax=-1000;lonmin=1000;lonmax=-1000
for s in geoshape :
    bbox = s.bbox
    latmin = min(latmin,bbox[1]);latmax=max(latmax,bbox[3]);
    lonmin = min(lonmin,bbox[0]);lonmax=max(lonmax,bbox[2]);
#print(str(latmin)+","+str(latmax)+","+str(lonmin)+","+str(lonmax))

latstep = (latmax - latmin) / resolution
lonstep = (lonmax - lonmin) / resolution

def collectCurrentData():
    data = {}
    for lat in numpy.arange(latmin - buff*latstep,latmax + buff*latstep,latstep):
        for lon in numpy.arange(lonmin - buff*lonstep,lonmax + buff*lonstep,lonstep):
            try :
                reqstr = 'http://aws.gobee.bike/GobeeBike/bikes/near_bikes?lat='+str(lat)+'&lng='+str(lon)+'&accuracy=20'
                #print(reqstr)
                req = requests.get(reqstr)
                currentdata = req.json()
                for b in currentdata['data']['bikes']:
                    b['ts']=numpy.round(time.time())
                    data[b['number']] = b
            except Exception :
                print(traceback.format_exc())
    return(data)



def updateData(currentdata):
    #print(currentdata)
    records = []
    cacheddata = database['cache'].find()
    prevdata = {}
    for c in cacheddata :
        prevdata[c['number']] = c
    for bid in currentdata.keys():
        b=currentdata[bid]
        if bid in prevdata.keys():
            prevb = prevdata[bid]
            # check if differences
            if b['lastUsageTimestamp']!=prevb['lastUsageTimestamp'] or numpy.round(b['gLat'],5)!=numpy.round(prevb['gLat'],5) or numpy.round(b['gLng'],5)!=numpy.round(prevb['gLng'],5) or b['power']!=prevb['power'] or b['hotspotDropoffDiscountAmount']!=prevb['hotspotDropoffDiscountAmount'] :
                b['type']='C'
                records.append(b)
        else :
            b['type']='A'
            records.append(b)
    for bid in prevdata.keys():
        if bid not in currentdata.keys() :
            b=prevdata[bid]
            # disapp data is superflous
            drec = {}
            drec['number']=bid;drec['ts']=b['ts'];drec['type']='D'
            records.append(drec)
    if len(records)>0 :
        database['data'].insert_many(records)
    database['cache'].delete_many({})
    database['cache'].insert_many(currentdata.values())


def runCollection():
    currentdata = collectCurrentData()
    updateData(currentdata)


runCollection()

print('Ellapsed Time :'+str(time.time() - start))
