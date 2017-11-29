
import pymongo,utils

params = {
  'dbport' : open('conf/dbport').readlines()[0].replace("\n",""),
  'dbauth' : open('conf/dbauth').readlines()[0].replace("\n",""),
  'dbname' : open('conf/dbname').readlines()[0].replace("\n","")
}


def setupdb():
    mongo = pymongo.MongoClient('mongodb://'+params['dbauth']+'@127.0.0.1:'+params['dbport'])
    database = mongo[params['dbname']]
    database['cache'].delete_many({})
    database['data'].delete_many({})



def main() :
    setupdb()



main()
