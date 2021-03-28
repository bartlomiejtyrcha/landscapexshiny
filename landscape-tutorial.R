library(landscapemetrics)
library(landscapetools)
library(raster)
library(dplyr)
??landscapemetrics
install.packages("rgdal")
#wczytanie rastrów

#plot(example_raster)
#plot(augusta)
# Sprawdzenie poprawności 
check_landscape(example_raster) 
check_landscape(augusta)
check_landscape(example_orto)
### Lista funkcji
lsmlist = list_lsm()
lsm_namestypes = distinct(lsmlist, name, type) 
filter(lsm_namestypes, type == 'area and edge metric')
?lsm_p_enn

filter(lsmlist, name == 'total area')

View(list_lsm())

list_lsm(level = 'patch')
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
moving_window <- matrix(1, nrow = 3, ncol = 3)
moving_window
result <- window_lsm(augusta, window = moving_window, what = c("lsm_l_pr", "lsm_l_joinent"))
result