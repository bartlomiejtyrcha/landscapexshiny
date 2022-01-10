library(shiny)
  
  
  #%>% editMap(viewer = dialogViewer("sampling", width = 600, height = 600) ,title = "Sample metrics", editor = "leaflet.extras", editorOptions = draw) 
shinyServer(function(input, output){
  map = leaflet() %>% 
    addTiles() %>% 
    addDrawToolbar(
      polylineOptions = FALSE,
      polygonOptions = FALSE,
      circleOptions = FALSE,
      rectangleOptions = FALSE,
      marker = drawMarkerOptions(),
      circleMarkerOptions = FALSE
    )
    
    inFile = reactive({raster::raster(input$file1$datapath)})
    observeEvent(input$file1$datapath, {
      output$rasterPlot = renderPlot({plot(inFile())})
    output$checklandscapeTable = renderDataTable(check_landscape(inFile())) # renderTable check_landscape()
    my_rast = raster::raster(input$file1$datapath)
    if(is.na(crs(my_rast))==TRUE){
      crs(my_rast) = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
    }
  
    my_ext = as.vector(extent(my_rast))
    
    plotInput = reactive(
      {
        {
          func_plot = function(input){
            if(input == "Landscape"){show_landscape(inFile())}
            else if(input == "Cores"){show_cores(inFile())}
            else if(input == "Patches"){show_patches(inFile())}
            else if(input == "Image"){plot(inFile())}
          }
        }
        func_plot(input$optionplot)
      })
    
    output$plot = renderPlot(
      {
        print(plotInput())
      })
    
    leafletProxy("map-map") %>% 
      addRasterImage(my_rast)  %>% 
      fitBounds(my_ext[1], my_ext[3], my_ext[2], my_ext[4])

    output$DownloadVisualization <- downloadHandler(
      filename = function() {
        paste0(Sys.time() %>% str_replace_all(
          pattern = "\\-",replacement = "\\_") %>% str_replace_all(
            pattern = "\\:", replacement = "\\") %>% str_replace(
              pattern = "\\ ", replacement = "\\_"), "_visualization", '.png')
      },
      content = function(file) {
        ggsave(file, plot = plotInput(), device = "png")
      }
    )
    
    })
    lsm_list = reactive(
        {
            landscapemetrics::list_lsm(level = input$level, metric = input$metric, name = input$name, type = input$type, what=input$function_name)
            }
        )
    
    observeEvent(input$run, {
        Calculate = reactive(
            {
                landscapemetrics::calculate_lsm(inFile(), 
                                                level = input$level, metric = input$metric,
                                                name = input$name, type = input$type, 
                                                what = input$function_name, directions = input$directions,
                                                count_boundary = input$count_boundary,
                                                consider_boundary = input$consider_boundary,
                                                edge_depth = input$edge_depth,
                                                cell_center = input$cell_center,
                                                classes_max = input$classes_max,
                                                neighbourhood = input$neighbourhood,
                                                ordered = input$ordered,
                                                base = input$base,
                                                full_name = input$full_name,
                                                verbose = input$verbose,
                                                progress = input$progress
                                                ) # Upload table, input - reactive()
                }
            )
        
        output$calculate = renderDataTable(Calculate()) # calculatelsm()
        
        output$downloadDataCSV <- downloadHandler(
            filename = function() {
                paste0(Sys.time() %>% str_replace_all(
                    pattern = "\\-",replacement = "\\_") %>% str_replace_all(
                        pattern = "\\:", replacement = "\\") %>% str_replace(
                            pattern = "\\ ", replacement = "\\_"), "_calculated.csv")
            },
            content = function(file) {
                write.csv(Calculate(), file, row.names = FALSE)
            }
        )
        output$downloadDataXLSX <- downloadHandler(
            filename = function(){
                paste0(Sys.time() %>% str_replace_all(
                    pattern = "\\-",replacement = "\\_") %>% str_replace_all(
                        pattern = "\\:", replacement = "\\") %>% str_replace(
                            pattern = "\\ ", replacement = "\\_"), "_calculated",".xlsx") 
            },
            content = function(file) {
                openxlsx::write.xlsx(Calculate(), file)
            }
        )
        

    }) #KONIEC INPUT RUN
    observeEvent(input$run2, {
      
      matrix_window = matrix(
        input$value_cell, 
        nrow = as.integer(input$nrowcol),
        ncol = as.integer(input$nrowcol)
      )
      Window = reactive(
            {
              landscapemetrics::window_lsm(inFile(),
                                           window = matrix_window,
                                           level = "landscape", name = input$landscape_name,
                                           type = input$landscape_type, what = input$landscape_function_name,
                                           progress = input$landscape_progress
                )
            }
        )
      moving_window_datatable = reactive(
        {
          if(length(input$landscape_function_name) == 1){
            landscapemetrics::calculate_lsm(unlist(Window()), what = input$landscape_function_name)
          }
          else{
            message("computation only possible for one 'what' value.")
          }
        }
      )
        output$plot2 = renderPlot(
            {
                {
                    func_plot = function(input){
                        if(input == "Landscape"){
                            show_landscape(Window())
                        }
                        else if(input == "Cores"){
                            show_cores(Window())
                        }
                        else if(input == "Patches"){
                            show_patches(Window())
                        }
                      else if(input == 'plot'){
                        plot(moving_window_datatable())
                      }
                    }
                }
            }
        )

        output$window_table = renderDataTable(moving_window_datatable())
        output$downloadDataCSV_movingwindow <- downloadHandler(
          filename = function() {
            paste0(Sys.time() %>% str_replace_all(
              pattern = "\\-",replacement = "\\_") %>% str_replace_all(
                pattern = "\\:", replacement = "\\") %>% str_replace(
                  pattern = "\\ ", replacement = "\\_"), "_window.csv")
          },
          content = function(file) {
            write.csv(moving_window_datatable(), file, row.names = FALSE)
          }
        )
        
        output$downloadDataXLSX_movingwindow <- downloadHandler(
          filename = function(){
            paste0(Sys.time() %>% str_replace_all(
              pattern = "\\-",replacement = "\\_") %>% str_replace_all(
                pattern = "\\:", replacement = "\\") %>% str_replace(
                  pattern = "\\ ", replacement = "\\_"), "_window",".xlsx") 
          },
          content = function(file) {
            openxlsx::write.xlsx(moving_window_datatable(), file)
          }
        )
    }
    ) #KONIEC INPUT RUN 2F
    edits = callModule(
      editMod,
      leafmap = map,
      id = "map"
    )
    observeEvent(input$save_sampling,
                 {
                   geom = edits()$finished
                   if(!is.null(geom)){
                     CalculateExtractLsm = reactive({landscapemetrics::extract_lsm(inFile(), y = geom, what = input$sampling_function_name)})
                     output$calculate_extractlsm = renderDataTable(CalculateExtractLsm())
                     output$downloadDataCSV_sampling <- downloadHandler(
                       filename = function() {
                         paste0(Sys.time() %>% str_replace_all(
                           pattern = "\\-",replacement = "\\_") %>% str_replace_all(
                             pattern = "\\:", replacement = "\\") %>% str_replace(
                               pattern = "\\ ", replacement = "\\_"), "_sampling.csv")
                       },
                       content = function(file) {
                         write.csv(CalculateExtractLsm(), file, row.names = FALSE)
                       }
                     )
                     
                     output$downloadDataXLSX_sampling <- downloadHandler(
                       filename = function(){
                         paste0(Sys.time() %>% str_replace_all(
                           pattern = "\\-",replacement = "\\_") %>% str_replace_all(
                             pattern = "\\:", replacement = "\\") %>% str_replace(
                               pattern = "\\ ", replacement = "\\_"), "_sampling",".xlsx") 
                       },
                       content = function(file) {
                         openxlsx::write.xlsx(CalculateExtractLsm(), file)
                       }
                     )
                     
                   }
                 }
                 
    )

  
})
