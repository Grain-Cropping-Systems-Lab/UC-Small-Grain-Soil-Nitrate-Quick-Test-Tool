library(shinydashboard)
library(googleway) # package for Google Map capabilities
library(shinycssloaders)
library(shinyWidgets)
library(dplyr)
library(shinyBS)

# load function that converts user input quick test values to lab and fertilizer equivalents
source("../functions/qtconverter_fn.R") 

# load the function that defines how different regions of the shapefile behave
# The shapefile we have loaded and defined allows users to select a point of interest within the agricultural soils of California.
# The soil nitrate quick test model was calibrated using these soils and we do not know its accuracy in other soils.
source("../functions/region_behavior_snqt_fn.R")

# load modules
source("../modules/dashboard_header.R")

# the map module uses a Google API key in order to be fully functional
source("../modules/map_module.R")
api_key <- Sys.getenv("MAPS_API_KEY")

# information specific to host's database
# the 'con' variable is used throughout to make calls to the database that stores all the soil data
# we use a spatially explicit table in a PostGres database for speed and ease of use with this large amount of data
readRenviron("../.Renviron")
con <- "ENTER DATABASE CONNECTION HERE"
