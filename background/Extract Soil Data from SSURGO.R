# This file shows how to compile SSURGO soil data in R into a shapefile for a region of interest. 


# load federal data packages
library(FedData)
library(readr)
library(tidyr)
library(dplyr)

# set working directory
# set HERE

# list of area symbols 
# The area_symbols are Survey Area Symbols that are used in the SSURGO soil data. 
# This csv represents all the areas that include parts of California. 
# Each area symbol is used to download the corresponding data for that area.
# For more information see SSURGODataPackagingandUse_6.doc & SSURGO_Metadata_-_Tables_and_Columns.pdf

area_symbols <- read_csv("Area_Symbols.csv")
complete_areas <- unlist(strsplit(list.files(pattern = ".shp"), ".shp"))
area_symbols <- area_symbols$area_symbols[(area_symbols$area_symbols %in% complete_areas)]

for (i in 1:length(area_symbols)){
	# grab individual data through r
	print(i)
	temp <- area_symbols[i]
	data <- get_ssurgo(template = c(temp), label = temp)
	# get individual tables and fields of interest
	mapunit <- data$tabular$mapunit %>% 
		dplyr::select(muname, farmlndcl, mukey)
	
	water <- data$tabular$muaggatt %>% 
		dplyr::select(aws025wta, aws050wta, aws0100wta, mukey)
	
	mapunit <- dplyr::inner_join(mapunit, water)
	
	component <- data$tabular$component %>% 
		dplyr::select(castorieindex, comppct.r, mukey, cokey)
	
	if (class(data$tabular$chorizon) != "NULL"){
		chorizon <- data$tabular$chorizon %>% 
			dplyr::select(cokey, hzdept.r, hzdepb.r, # add chkey?
						 sandtotal.r, silttotal.r, claytotal.r, om.r, dbovendry.r) %>% 
			filter(hzdept.r <= 30) # top foot of soil is 30 cm
		
		merged_data <- left_join(mapunit, component) %>% 
			left_join(chorizon) %>% 
			mutate(weighted_depth = if_else(hzdepb.r < 30, (hzdepb.r - hzdept.r)/30, (30 - hzdept.r)/30),
						 horizon_weight = (comppct.r/100)*weighted_depth) %>% 
			dplyr::select(-weighted_depth)
		
		mu_level <- merged_data %>% 
			dplyr::select(-cokey, -comppct.r, -hzdept.r, -hzdepb.r) %>% 
			gather(key = "measurement_name", value = "value", 
						 -mukey, -muname, -farmlndcl, -horizon_weight, 
						 -aws025wta, -aws050wta, -aws0100wta) %>% #bc water is on a mu level 
			drop_na(value) %>% 
			mutate(value = as.numeric(value)) %>% 
			group_by(mukey, muname, farmlndcl, aws025wta, aws050wta, aws0100wta, measurement_name) %>% 
			summarize(amount = weighted.mean(value, horizon_weight)) %>% 
			spread(measurement_name, amount)
	} else {
		chorizon <- NULL
		merged_data <- left_join(mapunit, component) %>% 
			dplyr::select(mukey, muname, farmlndcl) %>% 
			mutate(claytotal.r = NA, 
						 dbovendry.r = NA,
						 om.r = NA, 
						 sandtotal.r = NA, 
						 silttotal.r = NA)
		mu_level <- merged_data 
	}
	
	spatial <- data$spatial
	
	spatial2 <- sp::merge(spatial, mu_level, by.x = c("MUKEY"), 
												 by.y = c("mukey"))
	rgdal::writeOGR(spatial2, ".", layer = temp,
									overwrite_layer = TRUE,driver="ESRI Shapefile")
}

# list all shapefiles
shapefiles_list <- list.files(pattern = ".shp")

# read in all shapefiles on the list
shapefiles <- lapply(shapefiles_list, raster::shapefile)

# combine into one shapefile
one_file <- do.call(raster::bind, shapefiles)

# re-name fields in shapefile
names(one_file@data) <- tolower(gsub("_", "", names(one_file@data)))

one_file@data <- one_file@data[,c(1:9, 11:15)]


# write shapefile out as one shapefile into the current working directory (can easily change this by changing "." to the directory path
rgdal::writeOGR(one_file, ".", layer = "ssurgo_ca_soils", driver="ESRI Shapefile",
								overwrite_layer = TRUE)
