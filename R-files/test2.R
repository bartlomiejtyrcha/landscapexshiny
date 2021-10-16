list_lsm = list_lsm()


type = distinct(list_lsm, type)$type
level = distinct(list_lsm, level)$level
name = distinct(list_lsm, name)$name

patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")

metric_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(metric))
metric_landscape
as.list(metric_landscape)

example_raster = raster('example_raster/landscapes.tif')

type = distinct(list_lsm, type)$type
level = distinct(list_lsm, level)$level
name = distinct(list_lsm, name)$name
metric = distinct(list_lsm, metric)$metric
patch = filter(list_lsm, level == "patch")
landscape = filter(list_lsm, level == "landscape")
class = filter(list_lsm, level == "class")

metric_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(metric))
name_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(name))
type_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(type))
functions_landscape = as.list(filter(list_lsm, level == "landscape") %>% distinct(function_name))

level[3]

calculate_landscape = calculate_lsm(example_raster, what = "lsm_l_shdi" )
calculate_landscape
as.list(filter(list_lsm(), level == "landscape") %>% distinct(function_name))
siema = function(level){
  if(is.null(level) == TRUE){
    metric_by_level = distinct(list_lsm, metric)$metric
  }
  else{
    metric_by_level = as.list(filter(list_lsm(), level == level) %>% distinct(metric))
  }
  return(metric_by_level)
}
#################33 XD

funkcja = function(level){
  if(is.null(level) == TRUE){
    metric_by_level = distinct(list_lsm, metric)$metric
  }
  else{
    metric_by_level = as.list(filter(list_lsm(), level == level) %>% distinct(metric))
  }
  return(metric_by_level)
}

siema()
""
as.logical("")

a = NULL
is.null(a)

list_lsm
level = distinct(list_lsm, level = 'metric') %>% distinct(metric)
level
metric_filter = (filter(list_lsm, level == level[1]) %>% distinct(metric))$metric
metric_filter[1]
calculate_lsm(example_raster, level = 'class')
calculate_lsm(example_raster, level = 'patch')
calculate_lsm(example_raster, level = 'landscape')
plot(example_raster)

level = distinct(list_lsm, level)$level
level
level$'patch'
level[1]
  