
library(rjson)
library(httr)
library(rgdal)
library(dplyr)

setwd(paste0(Sys.getenv('CS_HOME'),'/CityBikes/Models/DataGobee'))

#paris = readOGR(dsn = '../../Data/gis/','paris')
idf = readOGR(dsn = '../../Data/gis/','irisidf')
paris = spTransform(idf[substr(idf$DEPCOM,1,2)=="75",],CRSobj = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# "http://aws.gobee.bike/GobeeBike/bikes/near_bikes?lat=48.85&lng=2.40&accuracy=20"

box=bbox(paris)
lngmin=box[1,1];lngmax=box[1,2]
latmin=box[2,1];latmax=box[2,2]

#plot(paris)

#resolutions=rep(seq(3,20),10)
#resolutions=sample(resolutions,size = length(resolutions),replace = F)
#resolutions=c(4,3)
resolutions=rep(10,10)
buffers = 1:5

i=0

startall = proc.time()[3]

bikenum=c();glngmin=c();glatmin=c();glngmax=c();glatmax=c()
cresols=c();cbuffers=c();ctimes=c()
for(resolution in resolutions){
  
  show(paste0(resolution," - ",i,"/",length(resolutions)))
  
  for(buffer in buffers){
    
    start = proc.time()[3]
    
    lngstep = (lngmax-lngmin)/resolution
    latstep = (latmax-latmin)/resolution
    
    allids = c();alllats=c();alllngs=c()
    for(lat in seq(latmin-(latmax-latmin)*buffer/resolution,latmax+(latmax-latmin)*buffer/resolution,latstep)){
      for(lng in seq(lngmin- (lngmax-lngmin)*buffer/resolution,lngmax+(lngmax-lngmin)*buffer/resolution,lngstep)){
        #show(paste0(lng,' - ',lat))
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
    #show(allids)
    bikenum=append(bikenum,length(allids));
    glngmin=append(glngmin,min(unlist(alllngs)));
    glngmax=append(glngmax,max(unlist(alllngs)));
    glatmin=append(glatmin,min(unlist(alllats)));
    glatmax=append(glatmax,max(unlist(alllats)));
    
    cresols = append(cresols,resolution)
    cbuffers = append(cbuffers,buffer)
    ctimes = append(ctimes,(proc.time()[3]-start))
    
    i=i+1
    
  }
}

res=data.frame(bikenum,glngmin,glngmax,glatmin,glatmax,cresols,cbuffers,ctimes)

#save(res,file='resol.RData')
save(res,file='buffers.RData')

show(paste0("Ellapsed time : ",(proc.time()[3]-startall),"s"))

#############

#load('resol.RData')

#sres <- as.tbl(res) %>% group_by(resolutions) %>% summarise(bikenumsd=sd(bikenum),bikes=mean(bikenum))

#g=ggplot(sres,aes(x=resolutions,y=bikes,ymin=bikes-bikenumsd,ymax=bikes+bikenumsd))
#g+geom_point()+geom_line()+geom_errorbar()+xlab("Resolution")+ylab("Number of bikes")+stdtheme
#ggsave(filename = 'resol.png',width = 15,height = 10,units = 'cm')




