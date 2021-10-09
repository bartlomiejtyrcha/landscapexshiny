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
