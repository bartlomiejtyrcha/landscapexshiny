library(shiny)

shinyServer(function(input, output){
    
    inFile = reactive(
        {
            raster::raster(input$file1$datapath) # Upload table, input - reactive()
            }
        )
    output$rasterPlot = renderPlot({plot(inFile())})
    
    output$checklandscapeTable = renderDataTable(check_landscape(inFile())) # renderTable check_landscape()
    
    lsm_list = reactive(
        {
            landscapemetrics::list_lsm(level = input$level, metric = input$metric, name = input$name, type = input$type, what=input$function_name)
            }
        )
    
    observeEvent(input$run, {
        
        output$plot = renderPlot(
            {
                {
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
                            show_correlation(Calculate() ## DO ZROBIENIA
                            )
                        }
                    }
                }
                func_plot(input$optionplot)
                }
            )
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
        Window = reactive(
            {
                landscapemetrics::window_lsm(inFile(),
                                             window = matrix(
                                                 input$value_cell, 
                                                 nrow = as.integer(input$nrowcol),
                                                 ncol = as.integer(input$nrowcol)
                                             ),
                                             level = "landscape", name = input$landscape_name,
                                             type = input$landscape_type, what = input$landscape_function_name,
                                             progress = input$landscape_progress
                )
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
                    }
                }
            }
        )
        output$window = renderDataTable(Window())
    }
    ) #KONIEC INPUT RUN 2
    
    observeEvent(input$level, {
        print(paste0("You have chosen: ", input$level))
    })
    
})
