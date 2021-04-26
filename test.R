pakiety = c('landscapemetrics', 'shiny', 'landscapetools', 'raster')
install.packages(pakiety)
library(shiny)
library(landscapemetrics)
library(landscapetools)
library(raster)
library(dplyr)
library(stringr)
landscapes = raster("landscapes.tif")


list_lsm = list_lsm()
patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")

#list_lsm$function_name

View(list_lsm)
show_landscape(augusta)

a = lsm_p_cai(augusta)
str(a)
a = landscapemetrics::augusta_nlcd
save.image("a.tif")

check_landscape(example_raster)
str(check_landscape(example_raster))
View(check_landscape(example_raster))



show_landscape(landscapes)
show_cores(landscapes)
show_patches(landscapes)

func = function(input){
  if(input == "Show landscape"){
    show_landscape(landscapes)
  }
  else if(input == "Show cores"){
    show_cores(landscapes)
  }
  else if(input == "Show patch"){
    show_patches(landscapes)
  }
  else if(input == "Image"){
    plot(landscapes)
  }
}
func("Image")
A = TRUE

landscapes = raster("example_raster/raster_1.tif")

calculate_lsm(example_raster, what = "lsm_c_area_sd", count_boundary = A,  edge_depth = 14)
calculate_lsm(landscapes, what = "lsm_c_area_sd", count_boundary = A, consider_boundary = FALSE, edge_depth = 14)

