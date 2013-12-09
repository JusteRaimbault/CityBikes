
#import of data from JSON file

#tries to know good format of output

library("rjson")

dataDir = "/Users/Juste/Documents/ComplexSystems/CityBikes/Data/test/data/"



#list of all stations
stations <- fromJSON(file="/Users/Juste/Documents/ComplexSystems/CityBikes/Data/testAPIBikes.json")
#sample = extractStationIds(stations,48.89,48.90,2.34,2.35)
#all stations:
sample = extractStationIds(stations,40,50,0,3)


extractStationIds<- function(sts,latmin,latmax,lonmin,lonmax){
  res = c()
  for(s in stations){
    if(s$position$lat>latmin&&s$position$lat<latmax&&s$position$lng>lonmin&&s$position$lng<lonmax){
      res = append(res,s$number)
    }
  }
  return(res)
}

getStationsCharacs <- function(){
  id=c();X = c();Y=c();capacity=c()
  for(s in stations){
    id = append(id,s$number)
    X = append(X,s$position$lng)
    Y = append(Y,s$position$lat)
    capacity = append(capacity,s$bike_stands)
  }
  return(data.frame(id,X,Y,capacity))
}

#write once and for all stations chars in one csv file
write.table(getStationsCharacs(),file="/Users/Juste/Documents/ComplexSystems/CityBikes/Data/stations/characs.csv")



n=length(dir(dataDir));p=length(sample)
dat = matrix(data=rep(0,n*p),nrow=n,ncol=p)

i=1
for(file in sort(dir(dataDir))){
  #epochs are supposed to be sorted?
  print(paste("Parsing file ",file))
  for(s in fromJSON(file=paste(dataDir,file,sep=""))){
    if(length(sample[which(sample==s$number)])>0){
      dat[i,which(sample==s$number)]=s$available_bikes
    }
  }
  i=i+1
}

#try a plot of time-series
par(mfcol=c(1,1))
plot(1:n,dat[,1],col=rainbow(p)[1],type="l",ylim=c(0,max(dat)),xlim=c(0,n))
for(j in 2:p){
  points(1:n,dat[,j],col=rainbow(p)[j],type="l")
}

