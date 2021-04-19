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
            fileInput("file1", "Choose raster file", accept = "image/*"), # Upload file - Input
            selectInput("level", "Choose a level:", 
                        list('patch' = patch$function_name,
                             'landscape' = landscape$function_name,
                             'class' = class$function_name
                        ), multiple = TRUE),
            textOutput("results")
        ),
        mainPanel(
            
            plotOutput("mapPlot")
                        )
        ),
    fluidRow(
        column(12,
               dataTableOutput('checklandscapeTable') # check_landscape() table - Output
        )
    )
    )


server = function(input, output){
    inFile = reactive({
        raster::raster(input$file1$datapath) # Upload table, input - reactive()
    })
    output$results = renderText({
        paste("You choose:")
        paste(input$level)
    })
    output$mapPlot = renderPlot( #Plot raster object
        {
            plot(inFile());
        }
    )
    #output$checklandscapeTable = renderDataTable(check_landscape(inFile())) # render Table 
}
            
# Run the application 
shinyApp(ui = ui, server = server)
