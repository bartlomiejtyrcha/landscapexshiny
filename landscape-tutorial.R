library(landscapemetrics)
library(landscapetools)
library(raster)
??landscapemetrics
#wczytanie rastrów
example_raster = raster("landscapes.tif")
example_orto = raster("ortofotomapa.tif")
augusta = landscapemetrics::augusta_nlcd
#plot(example_orto)
#plot(example_raster)
#plot(augusta)
# Sprawdzenie poprawności 
check_landscape(example_raster) 
check_landscape(augusta)
check_landscape(example_orto)
### Lista funkcji
View(list_lsm())

### Wizualizacja metryk - możliwość wyboru wizualizacji
show_landscape(example_raster)
show_patches(example_raster)
show_cores(example_raster)

show_landscape(augusta)
show_patches(augusta)
show_cores(augusta)
#get_patches(augusta) - możliwość wyboru wizualizacji konkretnej klasy
show_cores(augusta, class = c(11,21))

# show_lsm(landscape, what = "lsm_p_area", class = "global", label_lsm = TRUE)
show_lsm(augusta, what = "lsm_p_area")

# korelacja
show_correlation(calculate_lsm(augusta, what = "patch"), method = "pearson")


### MOVING WINDOWS