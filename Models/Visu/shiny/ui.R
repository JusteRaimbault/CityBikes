library(shiny)
library(leaflet)

shinyUI(
  navbarPage("City Bikes", id="nav",
      tabPanel("Interactive map", div(class="outer",
                tags$head(
                    includeCSS("styles.css"),
                    includeScript("gomap.js")
                          ),
                                
                leafletOutput("map", width="100%", height="100%"),
                         
                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                              width = 330, height = "auto",
                              sliderInput(inputId = "time","Time",min =0,max=24,value=12,step=0.1),
                              selectInput("date", "Date", dates)
                )
                       
      ))))