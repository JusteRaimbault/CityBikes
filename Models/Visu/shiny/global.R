
##
#  Data visualisation for citybikes data

# setwd(paste0(Sys.getenv('CS_HOME'),'/CityBikes/Models/Visu/shiny'))

library(rgeos)
library(rgdal)
library(spatstat)

# get raw files name
#  (daily data responsively loaded)

datafiles = list.files('data/raw')

dates = unlist(strsplit(datafiles,".csv"))

#test <- read.csv('data/1377727201.csv',sep=' ')
#plot(test[,1]/max(test[,1]),type='l');for(j in 2:20){points(test[,j]/max(test[,j]),type='l')}

# no unique id for stations -> on long time scale is not secure
# reprocess raw data with ids.

caracs = read.csv('data/characs.csv',sep=" ")

# construct voronoi diagram
stations = SpatialPoints(caracs[,2:3],proj4string = CRS('+proj=longlat +ellps=WGS84'))

voronoi = dirichlet(ppp(stations@coords[,1],stations@coords[,2],window = owin(xrange=c(min(stations@coords[,1]),max(stations@coords[,1])),yrange=c(min(stations@coords[,2]),max(stations@coords[,2])))))
polylist=lapply(tiles(voronoi),function(tile){Polygon(matrix(data=c(tile$bdry[[1]]$x,tile$bdry[[1]]$y),ncol=2,byrow=FALSE))})
spvoronoi = SpatialPolygons(list(Polygons(polylist,"ID")),proj4string = CRS('+proj=longlat +ellps=WGS84'))

plot(spvoronoi);points(stations,col='red',pch='.',cex=2)
