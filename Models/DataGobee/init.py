
import pymongo,utils



def setupdb():
    mongo = pymongo.MongoClient('mongodb://'+params.dbauth+'@127.0.0.1:'+params.dbport)
    database = mongo[params.dbname]
    # not needed




def main() :
    setupdb()



main()
