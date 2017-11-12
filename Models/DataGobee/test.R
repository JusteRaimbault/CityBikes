
library(rjson)
library(httr)
library(rgdal)

setwd(paste0(Sys.getenv('CS_HOME'),'/CityBikes/Models/DataGobee'))

#paris = readOGR(dsn = '../../Data/gis/','paris')
idf = readOGR(dsn = '../../Data/gis/','irisidf')
paris = spTransform(idf[substr(idf$DEPCOM,1,2)=="75",],CRSobj = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# "http://aws.gobee.bike/GobeeBike/bikes/near_bikes?lat=48.85&lng=2.40&accuracy=20"

box=bbox(paris)
lngmin=box[1,1];lngmax=box[1,2]
latmin=box[2,1];latmax=box[2,2]

#plot(paris)

resolutions=seq(4,20)
resolutions=sample(resolutions,size = length(resolutions),replace = F)

bikenum=c();glngmin=c();glatmin=c();glngmax=c();glatmax=c()
for(resolution in resolutions){

lngstep = (lngmax-lngmin)/resolution
latstep = (latmax-latmin)/resolution

allids = c();alllats=c();alllngs=c()
for(lat in seq(latmin-(latmax-latmin)/2,latmax+(latmax-latmin)/2,latstep)){
  for(lng in seq(lngmin- (lngmax-lngmin)/2,lngmax+ (lngmax-lngmin)/2,lngstep)){
    show(paste0(lng,' - ',lat))
    dat = content(GET(paste0("http://aws.gobee.bike/GobeeBike/bikes/near_bikes?lat=",lat,"&lng=",lng,"&accuracy=20")),type="application/json")
    bikes = dat[["data"]][["bikes"]]

    lats = sapply(bikes,function(l){l$gLat})
    lngs = sapply(bikes,function(l){l$gLng})
    ids = sapply(bikes,function(l){l$number})
    
    allids = unique(c(allids,ids))
    alllats = unique(c(alllats,lats))
    alllngs = unique(c(alllngs,lngs))
    
    #if(length(lats)>0&length(lngs)>0){
    #  points = SpatialPoints(matrix(data=c(lngs,lats),nrow = length(lats),byrow = F),proj4string = paris@proj4string)
    #  plot(points,col='red',add=T)
    #}
  }
}
bikenum=append(bikenum,length(allids));
glngmin=append(glngmin,min(alllngs));
glngmax=append(glngmax,max(alllngs));
glatmin=append(glatmin,min(alllats));
glatmax=append(glatmax,max(alllats));

}

res=data.frame(bikenum,glngmin,glngmax,glatmin,glatmax,resolutions)

save(res,file='resol.RData')




