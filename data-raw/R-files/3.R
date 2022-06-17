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

window_lsm(landscape,
               window = matrix(1, nrow = 3,ncol = 3),
               level = "landscape", name="patch area")
a = window_lsm(landscape = landscapes, window = matrix(1, 3,3), what = "lsm_l_pr")
calculate_lsm(unlist(a), what = "lsm_l_area_sd")
end_time <- Sys.time()

landscape = raster('example_raster/landscapes.tif')
landscapes = raster("example_raster/raster_1.tif")

data(landscape, package="landscapemetrics")
start_time <- Sys.time()
window_lsm(landscape = landscape, window = matrix(1, 3,3), what = "lsm_l_pr")
end_time <- Sys.time()
end_time - start_time

plot(landscape)
start_time - end_time

### MAPEDIT

install.packages("mapedit")
library(mapedit)
library(mapview)
library(leaflet)
library(leaflet.extras)

map = editMap(leaflet(), 
              title = "Sample metrics", 
              crs = 4326, 
              editor = "leaflet.extras") %>% addTiles()

draw = addDrawToolbar(
  polylineOptions = drawPolylineOptions(), 
  polygonOptions = FALSE,
  circleOptions = FALSE,
  rectangleOptions = FALSE,
  marker = drawMarkerOPtions(),
  circleMarkerOptions = FALSE)


what_we_created <- mapview() %>%
  editMap()

landscape = raster('Utils/NLMR_Example1.tif')
plot(landscape)

crs(landscape) = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
landscape
######### tu jest błąd
library(mapview)
library(mapedit)
library(sp)
library(sf)
what_we_created = mapview(landscape) %>% editMap()
my_draw = what_we_created$finished
str(my_draw[1])

plot(my_draw[[1]])
my_draw[[1]]
str(my_draw[[3]])
extract_lsm(landscape, y = my_draw[1], what = "lsm_p_area")
plot(my_draw[[3]])
