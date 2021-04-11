library(landscapemetrics)
library(landscapetools)
library(shiny)
library(raster)
library(dplyr)
list_lsm = list_lsm()
patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")
# Define UI for app that draws a histogram ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Landscapemetrics x Shiny"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            fileInput("file1", "Choose raster file", accept = "image/*"),
            selectInput("level", "Choose a level:",
                        list('patch' = patch$function_name,
                             'landscape' = landscape$function_name,
                             'class' = class$function_name
                        )),
            textOutput("results")
        ),
        mainPanel(
            
            plotOutput("mapPlot")
                        )
        )
    )


server = function(input, output){
    inFile = reactive({
        raster::raster(input$file1$datapath)
    })
    output$results = renderText({
        paste("You choose", input$level)
    })
    output$mapPlot = renderPlot(
        {
            plot(inFile());
        }
    )
}
            
# Run the application 
shinyApp(ui = ui, server = server)
