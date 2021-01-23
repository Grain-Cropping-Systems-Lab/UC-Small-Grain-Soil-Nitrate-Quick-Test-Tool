library(shinydashboard)
library(googleway) # package for Google Map capabilities
library(shinycssloaders)
library(shinyWidgets)
library(dplyr)
library(shinyBS)

# load function that converts user input quick test values to lab and fertilizer equivalents
source("../functions/qtconverter_fn.R") 

# load the function that defines how different regions of the shapefile behave
source("../functions/region_behavior_snqt_fn.R")

# load modules
source("../modules/dashboard_header.R")

# the map module uses a Google API key in order to be fully functional
source("../modules/map_module.R")
api_key <- Sys.getenv("MAPS_API_KEY")

# information specific to host's database
readRenviron("../.Renviron")
con <- "ENTER DATABASE CONNECTION HERE"
