#kernel estimations


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


x=seq(0,1,0.01)
y=seq(0,1,0.01)
g=gridMat(x,y)
k=rbfdot(sigma=100)
w=c(0,0,0,0)
points=matrix(data=c(0.2,0.2,0.8,0.2,0.8,0.8,0.2,0.8),byrow=TRUE,nrow=4)
km=kernelMult(kernel=k,x=g,y=points,z=w)
z=values(g,km,0.01)

persp(x=x,y=y,z=z,r=5,theta=20,phi=25,col="lightblue", ticktype = "detailed")


randomKernelVisu<-function(xmin,xmax,ymin,ymax,step,sigma,nPoints){
  
  x=seq(from=xmin,by=step,to = xmax)
  y=seq(from=ymin,by=step,to = ymax)
  g=gridMat(x,y)
  k=rbfdot(sigma=sigma)
  w=0.2+runif(nPoints)
  points=matrix(data=runif(2*nPoints),byrow=TRUE,nrow=nPoints)
  km=kernelMult(kernel=k,x=g,y=points,z=w)
  z=values(g,km,step)
  
  #persp(x=x,y=y,z=z,r=5,theta=100,phi=25,col="lightblue", ticktype = "detailed")
  
  
}





