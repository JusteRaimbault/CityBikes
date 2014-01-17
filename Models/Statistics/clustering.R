
#clustering of time series
#test and proceed

setwd("/Users/Juste/Documents/ComplexSystems/CityBikes/Data")

day <- as.matrix(read.table("data/1377727201.csv"))
stations <- as.matrix(read.table("stations/characs.csv"))

#calculation of loads factor
#seems extremely slow, WHY THE FUCK ?

normalize <- function(daydata){
  for(j in 1:length(daydata[1,])){
    #can't replace directly vector
    for(i in 1:length(daydata[,j])){
       daydata[i,j]<-daydata[i,j] / stations[j,4]
    }
  }
  return(daydata)
}

sample<-function(dat,timestep){
  return(dat[seq(from=1,length.out=floor(length(dat[,1])*5/timestep),by=floor(timestep / 5)),])
}



clusterNumber<-function(samplesSteps){
  k2=c();k3=c();
  n = normalize(day)
  par(mfcol=c(1,1))
  colors=colorRampPalette(c("red", "blue"))(length(samplesSteps))
  co=1
  for(s in samplesSteps){
    cluscoef = c()
    for(k in 2:20){
      print(paste(k,s,sep=" - "))
      km = kmeans(t(sample(n,s)),k,iter.max=30)
      cc=km$betweenss/km$totss
      cluscoef=append(cluscoef,cc)
      if(k==2){k2=append(k2,cc)};if(k==3){k3=append(k3,cc)};
    }
    #if(s==samplesSteps[1]){plot(2:20,cluscoef,col=colors[co],type="l",xlab="Cluster number",ylab="Clustering coefficient",ylim=c(0.3,1.05))}
    #else{points(2:20,cluscoef,col=colors[co],type="l")}
    co = co + 1
  }
  plot(samplesSteps,k2,type="l",xlab="Sampling step",ylab="c(k=2,3)",col=2,ylim=c(0.35,0.82))
  points(samplesSteps,k3,type="l",col=3)
}



#take the mean in dirty first approximation
provisoryTypicalWeekDay <- function(numdays){
  i=0
  for(file in sort(dir("data"))){
    print(paste("day",i))
     if(i<numdays){
       if(i==0){
         cumsum = normalize(as.matrix(read.table(paste("data/",file,sep=""))))
       }
       else{
         cumsum = cumsum + normalize(as.matrix(read.table(paste("data/",file,sep=""))))
       }
     }
    i = i + 1
  }
  write.table(signif(cumsum / numdays,3),file="stations/weekday.csv")
}


dayClustering <- function(numdays,sampling,dayclusternumber,finalclusternumber){
  i=0
  tstep = 24 * floor(60 / sampling)
  days = matrix(data=rep(0,numdays*tstep*dayclusternumber),nrow=numdays,ncol=tstep*dayclusternumber)
  for(file in sort(dir("data"))){
    print(paste("day",i))
    if(i<numdays){
        km = kmeans(t(sample(normalize(as.matrix(read.table(paste("data/",file,sep="")))),sampling)),dayclusternumber,iter.max=100)
        k=1
        for(c in km$centers){
          days[i,k]=c
          k=k+1
        }
    }
    i = i + 1
  }
  dayclustering = kmeans(days,finalclusternumber,iter.max=100)
  return(dayclustering$cluster)
}

drawClusteringCurves <- function(numdays){
  clusters <- dayClustering(numdays,5,50,2)
  
  i=0
  availableBikes1 = c();availableBikes2 = c();s1=0;s2=0
  for(file in sort(dir("data"))){
    if(i<numdays){
      dat = as.matrix(read.table(paste("data/",file,sep="")))
      av = c();
      for(l in 1:length(dat[,1])){
        av= append(av,sum(dat[l,]))
      }   
      if(length(availableBikes1)==0){availableBikes1=rep(0,length(av));availableBikes2=rep(0,length(av))}
      if(clusters[i+1]==1){availableBikes1=availableBikes1+av;s1=s1+1}
      else{availableBikes2=availableBikes2+av;s2=s2+1}
    }
    i = i + 1
  }
  plot(1:length(availableBikes1),availableBikes1/s1,type="l",col="red",ylim=c(10500,15000),xlab="time",ylab="Available bikes")
  points(1:length(availableBikes2),availableBikes2/s2,type="l",col="blue")
}






