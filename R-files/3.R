leaflet() %>%
  addTiles() %>% addDrawToolbar(position = "topright",polylineOptions = drawPolylineOptions(),
                                polygonOptions = FALSE,
                                circleOptions = FALSE,
                                rectangleOptions =FALSE,
                                markerOptions = drawMarkerOptions(repeatMode = TRUE),
                                circleMarkerOptions = FALSE)

landscape
window_lsm(landscape,
           window = matrix(
             1, 
             nrow = 1,
             ncol = 1
           ),
           level = "landscape", name = input$landscape_name,
           type = input$landscape_type, what = input$landscape_function_name,
           progress = input$landscape_progress
)

a = window_lsm(landscape,
           window = matrix(1, nrow = 3,ncol = 3), what = "lsm_l_pr")

show_landscape(a)

sleep_for_a_minute <- function() { Sys.sleep(60) }

start_time <- Sys.time()
landscape = raster('example_raster/landscapes.tif')

window_lsm(landscape,
               window = matrix(1, nrow = 3,ncol = 3),
               level = "landscape", name="patch area")
a = window_lsm(landscape = landscapes, window = matrix(1, 3,3), what = c("lsm_l_pr", "lsm_l_joinent"))
a[[1]]
str(a[1])
what = "lsm_l_area_sd"
length(a)
calculate_lsm(unlist(a), what = "lsm_l_area_sd")
end_time <- Sys.time()
start_time - end_time
plot(calculate_lsm(unlist(a), what = "lsm_l_area_sd"))
end_time - start_time

a
