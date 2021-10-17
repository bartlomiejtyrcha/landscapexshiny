library(shiny)
library(landscapemetrics)
library(landscapetools)
library(stringr)
library(shiny)
library(shinyWidgets)
library(shinycssloaders)
library(shinythemes)
library(raster)
library(openxlsx)
library(dplyr)
library(waiter)
source("function.R")
list_lsm = list_lsm()

type = distinct(list_lsm, type)$type
level = distinct(list_lsm, level)$level
name = distinct(list_lsm, name)$name
metric = distinct(list_lsm, metric)$metric
patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")

metric_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(metric))
name_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(name))
type_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(type))
functions_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(function_name))

options(shiny.maxRequestSize = 100*1024^2) # upload


# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
      useWaiter(),
      waiterPreloader(html = spin_circles()),
      waiterOnBusy(html = spin_circles()),
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
                                pickerInput(
                                  "level","Choose a level", 
                                  choices=as.vector(list_lsm() %>% distinct(level)), 
                                  options = list(`actions-box` = TRUE),
                                  multiple = T),
                                pickerInput(
                                  "metric", 
                                  "Choose a metric", 
                                  choices=metric, 
                                  options=list('actions-box' = TRUE),
                                  multiple = T),
                                pickerInput("type","Choose a type", choices=type, options = list(`actions-box` = TRUE),multiple = T),
                                pickerInput("name","Choose a name (???)", choices=name, options = list(`actions-box` = TRUE),multiple = T),
                                pickerInput("function_name","Choose a function", choices=list('patch' = patch$function_name, 'landscape' = landscape$function_name,
                                                                                              'class' = class$function_name), options = list(`actions-box` = TRUE),multiple = T),
                                numericInput("directions", "Directions", value = 8),
                                textOutput("results"),
                                selectInput("count_boundary", "count_boundary:",
                                            c(TRUE, FALSE), selected = FALSE),
                                selectInput("consider_boundary", "consider_boundary:", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE"),
                                numericInput("edge_depth", "edge_depth", value = 1),
                                selectInput("cell_center", "cell_center", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE"),
                                numericInput("classes_max", "classes_max", value = NULL),
                                numericInput("neighbourhood", "neighbourhood", value = 4),
                                selectInput("ordered", "ordered", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "TRUE"),
                                selectInput("base", "base", c("log2" = "log2", "log" = "log", "log10" = "log10", "bits" = "bits"), selected = "log2"),
                                selectInput("full_name", "full_name", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE"),
                                selectInput("verbose", "verbose", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "TRUE"),
                                selectInput("progress", "progress", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE")),
                            actionButton("run", label = "Run")
                   ), 
                   tabPanel("Moving window",
                            sidebarPanel(
                                numericInput("value_cell", "value_cell", value = 1),
                                numericInput("nrowcol", "nrowcol", value = 3),
                                pickerInput("landscape_metric", "Choose a metric", choices=metric_landscape, options=list('actions-box' = TRUE),multiple = T),
                                pickerInput("landscape_name","Choose a name", choices=name_landscape, options = list(`actions-box` = TRUE),multiple = T),
                                pickerInput("landscape_type","Choose a type", choices=type_landscape, options = list(`actions-box` = TRUE),multiple = T),
                                pickerInput("landscape_function_name","Choose a function", choices=functions_landscape, options = list(`actions-box` = TRUE),multiple = T),
                                selectInput("landscape_progress", "progress", c("TRUE" = TRUE, "FALSE" = FALSE), selected = "FALSE"),
                                actionButton("run2", label = "Run")
                            ),
                            mainPanel(
                                selectInput("optionplot2", "Choose an option:", c('Landscape','Cores', 'Patches')),
                                plotOutput("plot2"),),
                            fluidRow(
                                column(12,
                                       dataTableOutput('window')
                                )
                            )
                   ),
                   tabPanel("Results",
                            mainPanel(
                                downloadButton("downloadDataCSV", "Download CSV"),
                                downloadButton("downloadDataXLSX", "Download XSLX")
                            ),
                            fluidRow(
                                column(12, 
                                       dataTableOutput('calculate') # calculate_lsm() output
                                )
                            )
                   ),
                   tabPanel("Sampling around points of interest")
        ))
)
