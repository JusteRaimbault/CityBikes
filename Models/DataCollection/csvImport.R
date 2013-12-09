#reads all json files from current dir and outputs a csv resuming file in ..

#functions

extractStationIds<- function(sts,latmin,latmax,lonmin,lonmax){
  res = c()
  for(s in stations){
    if(s$position$lat>latmin&&s$position$lat<latmax&&s$position$lng>lonmin&&s$position$lng<lonmax){
      res = append(res,s$number)
    }
  }
  return(res)
}



library("rjson")

stations <- fromJSON(file="../../Data/stations/stations.json")
ids = extractStationIds(stations,40,50,0,3)

#reads in file current dir name 
dir <- scan("currentDir",what=character())

#setwd; supposed to have been created by shell script before
setwd(paste("../../Data/data/",dir,sep=""))
print(paste("working dir is", getwd()))


n=length(dir(getwd()));p=length(ids)
dat = matrix(data=rep(0,n*p),nrow=n,ncol=p)

i=1
for(file in sort(dir(getwd()))){
  if(file.info(file)$size>0){
    #epochs are supposed to be sorted?
    print(paste("Parsing file ",file))
    for(s in fromJSON(file=file)){
      if(length(ids[which(ids==s$number)])>0){
        dat[i,which(ids==s$number)]=s$available_bikes
      }
    }
    i=i+1
  }
}

#finally writes in csv file
setwd("../")
write.table(dat,file=paste(dir,".csv",sep=""))


