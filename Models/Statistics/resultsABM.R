setwd('/Users/Juste/Documents/ComplexSystems/CityBikes')


dat <- read.csv("Results/grid/repets.csv",sep=";")


histFit <-function(rows,col,n_repets,xlim,ylim,prop,xlab,colors){
  #rows in 0:(floor(length(dat[,1])/n_repets)-1)
  #n_repets = 500
  
  #plot.new()
  
  #par(mfcol=c(1,1))
  
  k=1
  
  for(i in rows){
    d = dat[(((i-1) * n_repets) + 1):(i*n_repets),col]
    #d = removeOutliers(d,prop)
    #c = paste("light",colors[k])
    #if(c=="light red"){c="red3"}
    h = hist(d,plot=TRUE,breaks=30,
             xlim=xlim,ylim=ylim,
             add=(i!=rows[1]),col=colors[k],
             xlab=xlab,main="")
    K = max(h$counts)
    curve(K*exp(- ((x - mean(d))^2)/(2*sd(d)^2)),add=TRUE,col=paste("darkred"),n=300,lwd=2)
    #plot(h$mids,h$counts)
    k=k+1
  }
}

par(mfcol=c(1,2))
histFit(c(1,2),577,50,c(1,2),c(0,8),0,"Detours",c("green","red"))
histFit(c(1,2),576,50,c(0,0.2),c(0,8),0,"Adverse events",c("green","red"))


dat <- read.csv("Results/grid/grid3rep.csv",sep=";")

#####################################
#plots 3D, as for calibration e. g.
######################################

grid <- read.csv("Results/Grid/calib.csv",sep=";")

plot3d <- function(reporterName,xParamName,yParamName, otherParams,otherParamsValues,theta,phi,title){
  
  x <- sort(unique(grid[[xParamName]]))
  y <- sort(unique(grid[[yParamName]]))
  z = matrix(nrow=length(x),ncol=length(y))
  xcors = matrix(nrow=length(x),ncol=length(y))
  ycors = matrix(nrow=length(x),ncol=length(y))
  for(i in 1:length(x)){
    for(j in 1:length(y)){
      z[i,j] = getReporterValue(c(xParamName,yParamName, otherParams),c(x[i],y[j], otherParamsValues),reporterName,grid)
      xcors[i,j]=x[i];ycors[i,j]=y[j]
    }
  }
  persp(x=x,y=y,z=z,r=10,theta=theta,phi=phi,col="lightblue",xlab=xParamName,ylab=yParamName,zlab=reporterName,shade = 0.75, ticktype = "detailed",cex.lab=0.8,cex.axis=0.6,main=title)
  
}

plot3d("mse.lf.timeseries","kernel.size","info.proportion",c("mean.tolerance.radius"),c(300),310,40,"MSE on lf-time-series")




#get corrsponding values after sorting
#quite dirty but should be quick, data are not so big
#don't forget to take the mean on all realisations !
getReporterValue <- function(paramNames,paramValues,repName,dat){
  cum = 0 ; reals = 0
  for(i in 1:length(dat[[paramNames[1]]])){
    j = 1
    eq = TRUE
    for(param in paramNames){
      eq = eq&&(dat[[param]][i]==paramValues[j])
      j = j + 1
    }
    if(eq){cum=cum+dat[[repName]][i];reals=reals+1}
  }
  if(reals==0){return(0)}
  else{return(cum/reals)}
}




#plot different time series for different values of r
#code from eco ABM

library(ggplot2)

eco <- read.csv("Results/Grid/radius4rep10rad2inf.csv",sep=";")

nrepets = 4
nrepetseco = 1
maxtime = 286
#beginindex_mlf = 3
step_index = 2

plotTS <- function(config_numbers,beginindex_mlf,ylab){
  mlf=c();mlfse=c();
  info=c();time=c();
  for(i in config_numbers - 1){
    for(j in 0:(maxtime-1)){
      s = unlist(grid[seq(from=(i* 20 ) + 1,by=1,length.out=4),beginindex_mlf + (step_index * j)])
      mlf = append(mlf,mean(s));
      mlfse=append(mlfse,sd(s));
      info=append(info,i*20)
      time=append(time,j)
    }	
  }
  dat = data.frame(heterogeneity=mlf,mlfse,info,time)
  
  limitsmlf <- aes(ymax = heterogeneity + mlfse, ymin= heterogeneity - mlfse)
  prent <- ggplot(dat, aes(colour=info, y= heterogeneity, x= time))
  prent + geom_line(aes(group=info)) + geom_errorbar(limitsmlf, width=0.2)
  
}

adverse=c()
for(i in 0:7){adverse=append(adverse,mean(eco[((8*i)+5):(8*(i+1)+4),577]))}
plot(seq(100,800,100),adverse,xlab="radius",type="l")


detours=c()
for(i in 0:7){detours=append(detours,mean(eco[((8*i)+5):(8*(i+1)+4),578]))}
plot(seq(100,800,100),adverse,xlab="radius",type="l")

#plots for information
adverse=c();adversesd=c();radius=c();
for(i in 0:5){
  d=grid[(((20*i)+9):((20*i)+13))+1,578]
  adverse=append(adverse,mean(d));adversesd=append(adversesd,sd(d));radius=append(radius,300)
}
for(i in 0:5){
  d=grid[(((20*i)+9):((20*i)+13))+121,578]
  adverse=append(adverse,mean(d));adversesd=append(adversesd,sd(d));radius=append(radius,700)
}

prent <- ggplot(data.frame(adverse,adversesd,radius,info=seq(0,100,20)), aes(colour=radius, y= adverse, x= info))
prent + geom_line(aes(group=radius)) + geom_errorbar(aes(ymax = adverse + adversesd, ymin= adverse - adversesd), width=0.2)

detours=c();detoursd=c();radius=c();
for(i in 0:5){
  d=grid[(((20*i)+9):((20*i)+13))+1,579]
  detours=append(detours,mean(d));detoursd=append(detoursd,sd(d));radius=append(radius,300)
}
for(i in 0:5){
  d=grid[(((20*i)+9):((20*i)+13))+121,579]
  detours=append(detours,mean(d));detoursd=append(detoursd,sd(d));radius=append(radius,700)
}

prent <- ggplot(data.frame(detours,detoursd,radius,info=seq(0,100,20)), aes(colour=radius, y= detours, x= info))
prent + geom_line(aes(group=radius)) + geom_errorbar(aes(ymax = detours + detoursd, ymin= detours - detoursd), width=0.2)






