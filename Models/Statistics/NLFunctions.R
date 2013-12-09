# functions called from NetLogo for setup and param



library(rgdal)


getStationsCharacs <- function(dataDir,gisFile){
  # extracts from GIS file the corresponding station
  # puts in global data frame
  
  stationsLayer <- as.data.frame(readOGR(paste(dataDir,"/gis",sep=""),gisFile))
  allStationsCharacs <-read.csv(paste(dataDir,"/stations/characs.csv",sep=""),sep=" ")
  
  
  #since coord come from *the same file* ! we can test as equal ?
  # well quite dangerous in all generality ?
  #no does not work in fact ! -> at epsilon
  ind=c();indices=(1:length(allStationsCharacs$X))
  for(i in 1:length(stationsLayer$X1)){
    i=which(abs(stationsLayer$X1[i]-allStationsCharacs$X)<0.0000001&abs(stationsLayer$X2[i]-allStationsCharacs$Y)<0.0000001)
    ind=append(ind,i)
  }
  return(allStationsCharacs[ind,])
}

getStationsIndexes <- function(dataDir,gisFile){
  # extracts from GIS file the corresponding station
  # puts in global data frame
  
  stationsLayer <- as.data.frame(readOGR(paste(dataDir,"/gis",sep=""),gisFile))
  allStationsCharacs <-read.csv(paste(dataDir,"/stations/characs.csv",sep=""),sep=" ")
  
  
  #since coord come from *the same file* ! we can test as equal ?
  # well quite dangerous in all generality ?
  #no does not work in fact ! -> at epsilon
  ind=c();indices=(1:length(allStationsCharacs$X))
  for(i in 1:length(stationsLayer$X1)){
    i=which(abs(stationsLayer$X1[i]-allStationsCharacs$X)<0.0000001&abs(stationsLayer$X2[i]-allStationsCharacs$Y)<0.0000001)
    ind=append(ind,i)
  }
  return(ind)
}

#stay on a typical weekday
getLoadFactors <- function(dataDir,gisFile){
  ind = getStationsIndexes(dataDir,gisFile)
  d = read.table(paste(dataDir,"/stations/weekday.csv",sep=""))
  return(d[,ind])
}





