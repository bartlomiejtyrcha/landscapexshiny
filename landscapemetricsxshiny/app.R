library(landscapemetrics)
library(landscapetools)
library(shiny)
library(shinyWidgets)
library(raster)
library(dplyr)
list_lsm = list_lsm()


type = distinct(list_lsm, type)$type
level = distinct(list_lsm, level)$level
name = distinct(list_lsm, name)$name
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
            fileInput("file1", "Choose raster file", accept = "image/*"),# Upload file - Input
            pickerInput("type","Choose a type", choices=type, options = list(`actions-box` = TRUE),multiple = T),
            pickerInput("level","Choose a level", choices=level, options = list(`actions-box` = TRUE),multiple = T),
            pickerInput("name","Choose a name (???)", choices=name, options = list(`actions-box` = TRUE),multiple = T),
            pickerInput("function_name","Choose a function", choices=list('patch' = patch$function_name, 'landscape' = landscape$function_name,
                                                                          'class' = class$function_name), options = list(`actions-box` = TRUE),multiple = T),
            textInput("directions", "Directions"),
            # selectInput("level", "Choose a level:", 
            #            list('patch' = patch$function_name,
            #                 'landscape' = landscape$function_name,
            #                 'class' = class$function_name
            #            ), multiple = TRUE),
            textOutput("results")
        ),
        mainPanel(
            
            plotOutput("mapPlot")
                        )
        ),
    fluidRow(
        column(12,
               dataTableOutput('checklandscapeTable'), # check_landscape() table - Output
               dataTableOutput('calculate') # calculate_lsm() output
        )
    )
    )


server = function(input, output){
    inFile = reactive({
        raster::raster(input$file1$datapath) # Upload table, input - reactive()
    })
    output$mapPlot = renderPlot( #Plot raster object
        {
            plot(inFile());
        }
    )
    output$checklandscapeTable = renderDataTable(check_landscape(inFile())) # renderTable check_landscape()
    output$calculate = renderDataTable(calculate_lsm(inFile(), level = input$level, 
                                                     name = input$name, type = input$type, 
                                                     what = input$function_name, directions = input$directions)) # calculatelsm()
}
            
# Run the application 
shinyApp(ui = ui, server = server)

