lsm_by_level = function(level_name){
  if(is.null(level_name)){
    list_lsm = list_lsm()
  }
  else{
    list_lsm = list_lsm() %>% filter(level %in% level_name)
  }
  return(list_lsm)
}

lsm_by_metric = function(metric_name){
  
  
  if(is.null(metric_name)){
    list_lsm = lsm_by_level(input$level)
  }
}

lsm_by_level("")

list_lsm(NULL, NULL, NULL, NULL)
