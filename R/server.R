#' main server of app
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#'
#' @return shiny server
#' @export
app_server = function(input, output, session) {


  map = leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet.extras::addDrawToolbar(
      polylineOptions = FALSE,
      polygonOptions = FALSE,
      circleOptions = FALSE,
      rectangleOptions = FALSE,
      marker = drawMarkerOptions(),
      circleMarkerOptions = FALSE
    )

  inFile = reactive({raster::raster(input$file1$datapath)})
  observeEvent(input$file1$datapath, {
    output$rasterPlot = renderPlot({raster::plot(inFile())})
    output$checklandscapeTable = renderDataTable(landscapemetrics::check_landscape(inFile())) # renderTable check_landscape()
    my_rast = raster::raster(input$file1$datapath)


    if(is.na(crs(my_rast))==TRUE){
      raster::crs(my_rast) = "EPSG:4326"
    }

    if(raster::crs(my_rast, asText=TRUE)!=crs("EPSG:4326", asText=TRUE)&&raster::crs(my_rast, asText=TRUE)!="+proj=longlat +datum=WGS84 +no_defs"){
      print("projectRaster")
      my_rast = raster::projectRaster(my_rast, crs = "EPSG:4326")
    }

    my_ext = as.vector(raster::extent(my_rast))

    plotInput = reactive(
      {
        {
          func_plot = function(input){
            if(input == "Landscape"){landscapetools::show_landscape(inFile())}
            else if(input == "Cores"){landscapemetrics::show_cores(inFile())}
            else if(input == "Patches"){landscapemetrics::show_patches(inFile())}
            else if(input == "Image"){raster::plot(inFile())}
          }
        }
        func_plot(input$optionplot)
      })

    output$plot = renderPlot(
      {
        print(plotInput())
      })

    leaflet::leafletProxy("map-map") %>%
      leaflet::addRasterImage(my_rast)  %>%
      leaflet::fitBounds(my_ext[1], my_ext[3], my_ext[2], my_ext[4])

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

    output$downloadDataCSV = downloadHandler(
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

    plotInputMovingWindow = reactive(
      {
        {
          func_plot = function(input){
            if(input == "Landscape"){
              landscapetools::show_landscape(unlist(Window())[[1]])
            }
            else if(input == "Cores"){
              landscapemetrics::show_cores(unlist(Window()))
            }
            else if(input == "Patches"){
              landscapemetrics::show_patches(unlist(Window()))
            }
            else if(input == 'Image'){
              raster::plot(unlist(Window())[[1]])
            }
          }
        }
        func_plot(input$optionplot2)
      })
    output$plot2 = renderPlot({print(plotInputMovingWindow())})
    output$window_table = renderDataTable(moving_window_datatable())
    output$downloadDataCSV_movingwindow = downloadHandler(
      filename = function() {
        paste0(Sys.time() %>% stringr::str_replace_all(
          pattern = "\\-",replacement = "\\_") %>% stringr::str_replace_all(
            pattern = "\\:", replacement = "\\") %>% stringr::str_replace(
              pattern = "\\ ", replacement = "\\_"), "_window.csv")
      },
      content = function(file) {
        write.csv(moving_window_datatable(), file, row.names = FALSE)
      }
    )

    output$downloadDataXLSX_movingwindow <- downloadHandler(
      filename = function(){
        paste0(Sys.time() %>% stringr::str_replace_all(
          pattern = "\\-",replacement = "\\_") %>% stringr::str_replace_all(
            pattern = "\\:", replacement = "\\") %>% stringr::str_replace(
              pattern = "\\ ", replacement = "\\_"), "_window",".xlsx")
      },
      content = function(file) {
        openxlsx::write.xlsx(moving_window_datatable(), file)
      }
    )
  }
  ) #KONIEC INPUT RUN 2F
  edits = callModule(
    mapedit::editMod,
    leafmap = map,
    id = "map"
  )
  observeEvent(input$save_sampling,
               {
                 extract_file = inFile()

                 geom = edits()$finished
                 if(is.na(raster::crs(extract_file))){
                   raster::crs(extract_file) = "EPSG:4326"
                 }
                 if(!is.null(geom)){
                   geom = sf::st_transform(geom, crs=sf::st_crs(raster::crs(extract_file, asText=TRUE)))
                   CalculateExtractLsm = reactive({landscapemetrics::extract_lsm(extract_file, y = geom, what = input$sampling_function_name)})
                   output$calculate_extractlsm = renderDataTable(CalculateExtractLsm())
                   output$downloadDataCSV_sampling = downloadHandler(
                     filename = function() {
                       paste0(Sys.time() %>% stringr::str_replace_all(
                         pattern = "\\-",replacement = "\\_") %>% stringr::str_replace_all(
                           pattern = "\\:", replacement = "\\") %>% stringr::str_replace(
                             pattern = "\\ ", replacement = "\\_"), "_sampling.csv")
                     },
                     content = function(file) {
                       write.csv(CalculateExtractLsm(), file, row.names = FALSE)
                     }
                   )

                   output$downloadDataXLSX_sampling = downloadHandler(
                     filename = function(){
                       paste0(Sys.time() %>% stringr::str_replace_all(
                         pattern = "\\-",replacement = "\\_") %>% stringr::str_replace_all(
                           pattern = "\\:", replacement = "\\") %>% stringr::str_replace(
                             pattern = "\\ ", replacement = "\\_"), "_sampling",".xlsx")
                     },
                     content = function(file) {
                       openxlsx::write.xlsx(CalculateExtractLsm(), file)
                     }
                   )

                 }
               }

  )
}
