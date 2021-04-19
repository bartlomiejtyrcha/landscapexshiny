library(dplyr)
library(landscapetools)
library(landscapemetrics)
library(shiny)
library(raster)
install.packages('shinyWidgets')
check_landscape(example_raster)
calculate_lsm(example_raster, what=c("lsm_c_te"))

View(list_lsm)
distinct(list_lsm, type)$type
distinct(list_lsm, level)$level
distinct(list_lsm, name)$name
patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")