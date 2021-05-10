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

ui <- 
  fluidPage(
    theme = shinytheme("darkly"), # THEME 
    navbarPage("landscapemetrics x shiny", 
               tabPanel(icon("home"), 
                        p("Homepage/index")), 
               tabPanel("Upload file",
                        sidebarPanel(
                          fileInput("file1", "Choose raster file", accept = "image/*")# Upload file - Input,
                        ),
                        mainPanel(plotOutput("rasterPlot"),
                        fluidRow(
                          column(12,
                                 dataTableOutput('checklandscapeTable') # check_landscape() table - Output
                                    )
                                  )
                        )),
               tabPanel("Visualization",
                        selectInput("optionplot", "Choose an option:", c('Image','Landscape','Cores', 'Patches',"Correlation")),
                        plotOutput("plot"),
                        p("Tu będzie przycisk do pobrania wizualizacji")),
               tabPanel("Calculate",
                        flowLayout(
                        pickerInput("type","Choose a type", choices=type, options = list(`actions-box` = TRUE),multiple = T),
                        pickerInput("level","Choose a level", choices=level, options = list(`actions-box` = TRUE),multiple = T),
                        pickerInput("name","Choose a name (???)", choices=name, options = list(`actions-box` = TRUE),multiple = T),
                        pickerInput("function_name","Choose a function", choices=list('patch' = patch$function_name, 'landscape' = landscape$function_name,
                                                                          'class' = class$function_name), options = list(`actions-box` = TRUE),multiple = T),
                        textInput("directions", "Directions", value = 8),
                        textOutput("results"),
                        selectInput("count_boundary", "count_boundary:",
                                    c("TRUE" = TRUE,
                                      "FALSE" = FALSE), selected = "FALSE"),
                        #selectInput("consider_boundary", "consider_boundary:", 
                          #          c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE")
                        textInput("edge_depth", "edge_depth", value = 1),
                        selectInput("cell_center", "cell_center", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE"),
                        textInput("classes_max", "classes_max", value = NULL),
                        textInput("neighbourhood", "neighbourhood", value = 4),
                        selectInput("ordered", "ordered", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "TRUE"),
                        selectInput("base", "base", c("log2" = "log2", "log" = "log", "log10" = "log10", "bits" = "bits"), selected = "log2"),
                        selectInput("full_name", "full_name", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE"),
                        selectInput("verbose", "verbose", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "TRUE"),
                        selectInput("progress", "progress", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE")),
                        actionButton("run", label = "Run")
                        ), 
    tabPanel("Results",
             mainPanel(
               downloadButton("downloadData", "Download CSV")
             ),
             fluidRow(
               column(12, 
                      dataTableOutput('calculate') # calculate_lsm() output
                      )
               )
             )
    ))
    
server = function(input, output){
    inFile = reactive({
        raster::raster(input$file1$datapath) # Upload table, input - reactive()
    })
    observeEvent(input$run, {
    #output$mapPlot = renderPlot( #Plot raster object
    #    {
    #        plot(inFile());
    #    }
    #)
    output$rasterPlot = renderPlot({plot(inFile())})
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
            else if(input == "Correlation"){
                show_correlation(calculate_lsm(inFile(), level = input$level, 
                                               name = input$name, type = input$type, 
                                               what = input$function_name, directions = input$directions,
                                               count_boundary = input$count_boundary,
                                               #consider_boundary = input$consider_boundary
                                               edge_depth = input$edge_depth,
                                               cell_center = input$cell_center,
                                               classes_max = input$classes_max,
                                               neighbourhood = input$neighbourhood,
                                               ordered = input$ordered,
                                               base = input$base,
                                               full_name = input$full_name,
                                               verbose = input$verbose,
                                               progress = input$progress
                ))
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
                                                     count_boundary = input$count_boundary,
                                                     #consider_boundary = input$consider_boundary
                                                     edge_depth = input$edge_depth,
                                                     cell_center = input$cell_center,
                                                     classes_max = input$classes_max,
                                                     neighbourhood = input$neighbourhood,
                                                     ordered = input$ordered,
                                                     base = input$base,
                                                     full_name = input$full_name,
                                                     verbose = input$verbose,
                                                     progress = input$progress
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
    })}

            
# Run the application 
shinyApp(ui = ui, server = server)

