leaflet() %>%
  addTiles() %>% addDrawToolbar(position = "topright",polylineOptions = drawPolylineOptions(),
                                polygonOptions = FALSE,
                                circleOptions = FALSE,
                                rectangleOptions =FALSE,
                                markerOptions = drawMarkerOptions(repeatMode = TRUE),
                                circleMarkerOptions = FALSE)
