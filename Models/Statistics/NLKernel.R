
#kernel functions

gridMat <- function(x,y){
  res <- matrix(data=rep(0,2*length(x)*length(y)),ncol=2,nrow=length(x)*length(y))
  k=1
  for(i in 1:length(x)){
    for(j in 1:length(y)){
      res[k,1]=x[i];res[k,2]=y[j]
      k=k+1
    }
  }
  return(res)
}

values <- function(points,v,step){
  res <- matrix(data=rep(0,length(x)*length(y)),ncol=length(x),nrow=length(y))
  for(k in 1:length(v)){
    res[round(points[k,1]/step) + 1,round(points[k,2]/step) + 1]=v[k]
  }
  return(res)
}

#vars put from NL
#realArrivals
#dataSpatialWidthStep
#xPoints
#yPoints
#sigma
#tmax

library("kernlab")

realArrivals <- matrix(data=unlist(realArrivals),nrow=tmax,ncol=length(xPoints))
realDepartures<- matrix(data=unlist(realDepartures),nrow=tmax,ncol=length(xPoints))

xmax=max(xPoints);xmin=min(xPoints);ymax=max(yPoints);ymin=min(yPoints)
xrange=xmax-xmin;yrange=ymax-ymin

#let do rescaling of x,y to be between 0 and 1
xPoints = (xPoints - xmin)/xrange
yPoints = (yPoints - ymin)/yrange

#dataSpatialHeightStep=floor(yrange*dataSpatialWidthStep/xrange)
arrivals=matrix(data=rep(0,tmax*dataSpatialWidthStep*dataSpatialWidthStep),nrow=tmax,ncol=(dataSpatialWidthStep+1)^2)
departures=matrix(data=rep(0,tmax*dataSpatialWidthStep*dataSpatialWidthStep),nrow=tmax,ncol=(dataSpatialWidthStep+1)^2)

x=seq(0,1,1/dataSpatialWidthStep)
y=seq(0,1,1/dataSpatialWidthStep)

g=gridMat(x,y)
ker=rbfdot(sigma=sigma)
for(t in 1:tmax){
    wa=realArrivals[t,]
    wd=realDepartures[t,]
    points=matrix(data=c(xPoints,yPoints),byrow=FALSE,nrow=length(wa))
    kma=kernelMult(kernel=ker,x=g,y=points,z=wa)
    za=values(g,kma,1/dataSpatialWidthStep)
    kmd=kernelMult(kernel=ker,x=g,y=points,z=wd)
    zd=values(g,kmd,1/dataSpatialWidthStep)
    k=1
    for(i in 1:length(za[,1])){
      for(j in 1:length(za[1,])){
        arrivals[t,k]=za[i,j]
        departures[t,k]=zd[i,j]
        k=k+1
      }
    }
  }

arrivals<-data.frame(arrivals)
departures<-data.frame(departures)
