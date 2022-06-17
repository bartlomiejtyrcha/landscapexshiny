#' Run the Shiny Application
#'
#' @param options optional, described in ?shiny::shinyApp
#' @param ... arguments to pass to golem_opts
#' @importFrom shiny shinyApp
#' @export
run_app = function(options = list()) {
  library(landscapemetrics)
  library(landscapetools)
  library(stringr)
  library(shiny)
  library(shinyWidgets)
  library(shinycssloaders)
  library(shinythemes)
  library(raster)
  library(openxlsx)
  library(dplyr)
  library(waiter)
  library(leaflet)
  library(leaflet.extras)
  library(mapedit)
  library(sf)
  library(rgdal)
  list_lsm = list_lsm()

  type = dplyr::distinct(list_lsm, type)$type
  level = dplyr::distinct(list_lsm, level)$level
  name = sort(dplyr::distinct(list_lsm, name)$name)
  metric = sort(dplyr::distinct(list_lsm, metric)$metric)
  patch = dplyr::filter(list_lsm, level == "patch")
  landscape = dplyr::filter(list_lsm, level == "landscape")
  class = dplyr::filter(list_lsm, level == "class")

  metric_landscape = as.list(dplyr::filter(list_lsm, level == "landscape") %>% dplyr::distinct(metric))
  name_landscape = as.list(dplyr::filter(list_lsm, level == "landscape") %>% dplyr::distinct(name))
  type_landscape = as.list(dplyr::filter(list_lsm, level == "landscape") %>% dplyr::distinct(type))
  functions_landscape = as.list(dplyr::filter(list_lsm, level == "landscape") %>% dplyr::distinct(function_name))

  name_patch = as.list(dplyr::filter(list_lsm, level == "patch") %>% dplyr::distinct(name))
  type_patch = as.list(dplyr::filter(list_lsm, level == "patch") %>% dplyr::distinct(type))
  functions_patch = as.list(dplyr::filter(list_lsm, level == "patch") %>% dplyr::distinct(function_name))

  options(shiny.maxRequestSize = 100*1024^2) # upload
  shiny::shinyApp(ui = app_ui,
                  server = app_server,
                  options = options)

}
