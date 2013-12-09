

stations <- fromJSON(file="/Users/Juste/Documents/ComplexSystems/CityBikes/Data/testAPIBikes.json")

test1<-function(){
	for(s in stations){
		print(s$position)
	}
}


extractStations<- function(sts,latmin,latmax,lonmin,lonmax){
	res = c()
	for(s in stations){
		if(s$position$lat>latmin&&s$position$lat<latmax&&s$position$lng>lonmin&&s$position$lng<lonmax){
			res = list(unlist(res,recursive=FALSE),s)
		}
	}
	return(res)
}

coordinates<-function(sts){
	res = c()
	for(s in stations){
		res=c(res,s$position$lng,s$position$lat)
	}
	return(res)
}

testExtract<-function(){
	length(stations)
	length(extractStations(stations,48.87,48.90,2.33,2.35))
	length(extractStations(stations,48.89,48.90,2.34,2.35))
}



library(rgdal)
testRgdal<-function(){
	coords <- matrix(data=coordinates(stations),ncol=2,byrow=TRUE)
	writeOGR(SpatialPointsDataFrame(coords,data.frame(coords)), "/Users/Juste/Documents/ComplexSystems/CityBikes/Data", "test", driver="ESRI Shapefile",overwrite_layer=TRUE)
}

roads <- readOGR("/Users/Juste/Documents/ComplexSystems/CityBikes/Data/ile-de-france-latestshp","roads")


