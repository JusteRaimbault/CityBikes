library(shiny)
library(leaflet)
library(RColorBrewer)

shinyServer(function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 2.34, lat = 48.85, zoom = 12)
  })
  
  
  observe({
    
    
    
    
  })
  
  
})