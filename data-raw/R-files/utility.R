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

set.seed(2020-01-01)

single_landscape_create = function(x) {
  NLMR::nlm_randomcluster(ncol = 80, nrow = 80, resolution = 50, p = 0.4, ai = c(0.25, 0.25, 0.5),
                          rescale = FALSE)
}
landscape <- single_landscape_create()
plot(landscape)
crs(landscape) = "EPSG:2180"
writeRaster(landscape, 'NLMR_Raster1_A.tif', overwrite=TRUE)


what_we_created = mapview(landscape) %>% editMap()
my_draw = what_we_created$finished
plot(my_draw)
extract_lsm(landscape, y = my_draw[1], what = "lsm_p_area")

random_gaussian = NLMR::nlm_gaussianfield(nrow = 80, ncol = 80, resolution = 50,
                                          autocorr_range = 5)
random_gaussian
plot(random_gaussian)
crs(random_gaussian) = "EPSG:2180" 
writeRaster(random_gaussian, 'NLMR_Raster1_A.tif', overwrite=TRUE)
a = raster('NLMR_Raster1_A.tif')
plot(a)

set.seed(Sys.Date())
single_landscape_create = function(x) {
  NLMR::nlm_randomcluster(ncol = 40, nrow = 40, resolution = 60, p = 0.5, ai = c(0.25, 0.25, 0.5),
                          rescale = FALSE)
}
landscape2 <- single_landscape_create()
plot(landscape2)
writeRaster(landscape2, 'NLMR_Raster2_A.tif', overwrite=TRUE)

png("test_rasters.png", width = 1500, height = 500)
par(mfrow=c(1,2))
plot(landscape)
plot(landscape2, legend=FALSE)
dev.off()

set.seed(2018-05-12)









single_landscape_create = function(x) {
  NLMR::nlm_randomcluster(ncol = 50, nrow = 50, p = 0.4, ai = c(0.25, 0.25, 0.5),
                          rescale = FALSE)
}
landscape <- single_landscape_create()
plot(landscape)
calculate_lsm(landscape, what = "lsm_l_area_sd")





writeRaster(landscape, 'NLMRtest.tif', overwrite=TRUE)
crs(landscape) = "EPSG:2180"
library(mapview)
library(mapedit)
library(sp)
library(sf)
library(landscapemetrics)
landscape = raster('Utils/landscapes.tif')
crs(landscape) = "EPSG:2180"
landscape_projected = projectRaster(landscape, crs = "EPSG:4326")

what_we_created = mapview(landscape) %>% editMap()
my_draw = what_we_created$finished
st_transform(my_draw, "EPSG:2180")
plot(my_draw)
extract_lsm(landscape, y = my_draw[1], what = "lsm_p_area")
landscape
check_landscape(landscape)

check_landscape(landscape)
landscape
plot(landscape)
landscape_empty = projectExtent(landscape, "EPSG:4326")
landscape_projected = projectRaster(landscape, crs = "EPSG:4326")
plot(landscape_projected)
res(landscape)
res(landscape_projected)
hist(landscape)
hist(landscape_projected)
check_landscape(landscape_projected)


what_we_created = mapview(landscape_projected) %>% editMap()

my_draw = what_we_created$finished


plot(my_draw)

extract_lsm(landscape_projected, y = my_draw[1], what = "lsm_p_area")

calculate_landscape = calculate_lsm(landscape_projected, what = "lsm_l_shdi" )
