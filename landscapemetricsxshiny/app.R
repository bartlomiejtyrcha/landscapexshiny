library(landscapemetrics)
library(landscapetools)
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(raster)
library(dplyr)
list_lsm = list_lsm()


type = distinct(list_lsm, type)$type
level = distinct(list_lsm, level)$level
name = distinct(list_lsm, name)$name
patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")


options(shiny.maxRequestSize = 100*1024^2) # upload
# Define UI for app that draws a histogram ----
ui <- fluidPage(
    theme = shinytheme("darkly"),
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
            textInput("directions", "Directions", value = 8),
            # selectInput("level", "Choose a level:", 
            #            list('patch' = patch$function_name,
            #                 'landscape' = landscape$function_name,
            #                 'class' = class$function_name
            #            ), multiple = TRUE),
            textOutput("results"),
            selectInput("count_boundary", "count_boundary:",
                        c("TRUE" = TRUE,
                          "FALSE" = FALSE), selected = "FALSE")#,
            #selectInput("consider_boundary", "consider_boundary:", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE")
        ),
        mainPanel(
            selectInput("optionplot", "Choose an option:", c('Image','Landscape','Cores', 'Patches')),
            plotOutput("plot"),
            #plotOutput("mapPlot"), #Raster plot
            #plotOutput("PlotLandscape"), #show_landscape()
            #plotOutput("PlotPatch"), #show_patches
            #plotOutput("PlotCore"),
            downloadButton("downloadData", "Download CSV")
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
    #output$mapPlot = renderPlot( #Plot raster object
    #    {
    #        plot(inFile());
    #    }
    #)
    output$plot = renderPlot({{
        func_plot = function(input){
            if(input == "Landscape"){
                show_landscape(inFile())
            }
            else if(input == "Cores"){
                show_cores(inFile())
            }
            else if(input == "Patches"){
                show_patches(inFile())
            }
            else if(input == "Image"){
                plot(inFile())
            }
        }
    }
    func_plot(input$optionplot)}
        
    )
    #output$PlotLandscape = renderPlot({show_landscape(inFile())})
    #output$PlotPatch = renderPlot({show_patches(inFile())})
    #output$PlotCore = renderPlot({show_cores(inFile())})
    output$checklandscapeTable = renderDataTable(check_landscape(inFile())) # renderTable check_landscape()
    output$calculate = renderDataTable(calculate_lsm(inFile(), level = input$level, 
                                                     name = input$name, type = input$type, 
                                                     what = input$function_name, directions = input$directions,
                                                     count_boundary = input$count_boundary#,
                                                     #consider_boundary = input$consider_boundary
                                                     )) # calculatelsm()
    output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$calculate, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(calculate_lsm(inFile(), level = input$level, 
                              name = input$name, type = input$type, 
                              what = input$function_name, directions = input$directions,
                              count_boundary = input$count_boundary), file, row.names = FALSE)
    }
  )
}
            
# Run the application 
shinyApp(ui = ui, server = server)

