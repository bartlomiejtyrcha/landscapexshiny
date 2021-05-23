pakiety = c('landscapemetrics', 'shiny', 'landscapetools', 'raster')
install.packages(pakiety)
install.packages("raster", type = "source")
install.packages("igraph")
landscapes = raster("example_raster/landscapes.tif")
#install.packages("NLMR")
devtools::install_github("ropensci/NLMR")
install.packages("libproj")
install.packages("gdal")
install.packages("xlsx")
library(rgdal)
library(shiny)
library(landscapemetrics)
library(landscapetools)
library(raster)
library(dplyr)
library(stringr)
library(igraph)
library(NLMR)
library(xlsx)
library(libproj)
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

set.seed(2021-05-23)
a = nlm_fbm(50, 50, resolution = 100, fract_dim = 0.5)
plot(a)
str(a)
writeRaster(a, "example_20210523", format = "GTiff", overwrite = TRUE)

plot(raster("example_20210523.tif"))


set.seed(2021-05-22)
a = nlm_fbm(50, 50, resolution = 100, fract_dim = 0.5)
plot(a)

Sys.time() %>% str_replace_all(
  pattern = "\\-",replacement = "\\_") %>% str_replace_all(
    pattern = "\\:", replacement = "\\") %>% str_replace(
      pattern = "\\ ", replacement = "\\_")

paste0(Sys.time() %>% str_replace_all(
  pattern = "\\-",replacement = "\\_") %>% str_replace_all(
    pattern = "\\:", replacement = "\\") %>% str_replace(
      pattern = "\\ ", replacement = "\\_"), "_calculated.csv")
calculate_lsm(a, what = "lsm_c_area_sd")

write.xlsx(calculate_lsm(a, what = "lsm_c_area_sd"), file = paste0(Sys.time() %>% str_replace_all(
  pattern = "\\-",replacement = "\\_") %>% str_replace_all(
    pattern = "\\:", replacement = "\\") %>% str_replace(
      pattern = "\\ ", replacement = "\\_"), "_calculated",".xlsx"), row.names = FALSE)
