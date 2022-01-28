# landscapexshiny
<div style="float:right; clear: right"><a href="https://r-spatialecology.github.io/landscapemetrics/"><img src="logo.png" alt="logo" width="25%"/></a></div>

## _Interactive application supporting the calculation of landscape metrics_



__landscapexshiny__ is a Shiny app for supporting the  __landscapemetrics__ package in calculating landscape metrics for categorical landscape patterns.


## Features

- Import of a raster file and its visualization 
- Visualization of landscapes, cores and patches
- Calculation of landscape metrics and their export to __csv__ and __xlsx__
- Implementation of moving windows in landscapemetrics

## Tech

landscapexshiny uses a number of open source projects to work properly:

- [shiny] - Web Application Framework for R
- [landscapemetrics] is a R package for calculating landscape metrics for categorical landscape patterns in a tidy workflow
- [landscapetools] provides utility functions to work with landscape data (raster* Objects)
- [stringr]
- [shinyWidgets], [shinythemes], [shinycssloaders], [waiter] - GUI
- [openxlsx] - Export to XLSX (Microsoft Excel) file
- [dplyr]

## Installation

```
library(shiny)
runGitHub("landscapexshiny", "bartlomiejtyrcha")
```

## License

MIT

[//]: #

   [landscapemetrics]: <https://github.com/r-spatialecology/landscapemetrics>
   [landscapetools]: <https://github.com/ropensci/landscapetools>
   [shiny]: <https://github.com/rstudio/shiny>
   [stringr]: <https://github.com/tidyverse/stringr>
   [shinyWidgets]: <https://github.com/dreamRs/shinyWidgets>
   [shinycssloaders]: <https://github.com/daattali/shinycssloaders>
   [shinythemes]: <https://github.com/rstudio/shinythemes>
   [raster]: <https://github.com/rspatial/raster>
   [openxlsx]: <https://github.com/ycphs/openxlsx>
   [dplyr]: <https://github.com/tidyverse/dplyr>
   [waiter]: <https://github.com/JohnCoene/waiter>
