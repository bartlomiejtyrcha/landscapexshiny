library(landscapemetrics)
library(landscapetools)
library(raster)
install.packages("bench")

landscapes = raster("example_raster/landscapes.tif")

get_patches(landscapes)
get_adjacencies(landscapes, neighbourhood = 4)

diagonal_matrix <- matrix(c(1,  NA,  1,
                            NA,  0, NA,
                            1,  NA,  1), 3, 3, byrow = TRUE)
get_adjacencies(landscapes, diagonal_matrix)


adj_raster <- function(landscapes){
  adjacencies <- raster::adjacent(landscape, 
                                  cells = 1:raster::ncell(landscape), 
                                  directions = 4, 
                                  pairs = TRUE)
  table(landscape[adjacencies[,1]], landscape[adjacencies[,2]])
}


bench::mark(
  get_adjacencies(landscape, neighbourhood = 4),
  adj_raster(landscape),
  iterations = 100, 
  check = FALSE
)

install.packages("NLMR")

# nlm_gaussianfield
library(NLMR)
library(raster)
as.Date()

set.seed(Sys.Date())

random_gaussian = NLMR::nlm_gaussianfield(nrow = 80, ncol = 80, resolution = 50,
                                          autocorr_range = 5)
random_gaussian
plot(random_gaussian)
crs(random_gaussian) = "EPSG:2180" 
writeRaster(random_gaussian, 'NLMR_Raster1_A.tif', overwrite=TRUE)
a = raster('NLMR_Raster1_A.tif')
plot(a)


random_gaussian = NLMR::nlm_gaussianfield(nrow = 40, ncol = 40, resolution = 60,
                                          autocorr_range = 10)
random_gaussian
plot(random_gaussian)
writeRaster(random_gaussian, 'NLMR_Raster2_A.tif', overwrite=TRUE)
a = raster('NLMR_Raster2_A.tif')
plot(a)
a
