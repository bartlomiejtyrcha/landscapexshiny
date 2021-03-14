pakiety = c('landscapemetrics', 'shiny', 'landscapetools', 'raster')
install.packages(pakiety)
library(shiny)
library(landscapemetrics)
library(landscapetools)
library(raster)
landscapes = raster("landscapes.tif")


