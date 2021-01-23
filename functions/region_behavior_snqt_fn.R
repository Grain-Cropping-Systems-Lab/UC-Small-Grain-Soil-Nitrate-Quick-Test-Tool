region_behavior_snqt <- function(shapefile, region_data, current_markers, testing_markers){
	if(is.na(region_data$region)){
		print("NA region")
		print(region_data$region)
		showNotification("Error: no data for this location!", id = "region_error")
	} else {
		print("real region")
		print(region_data$region)
		current_markers$lat <- testing_markers$lat
		current_markers$lon <- testing_markers$lon
	}
	
	return(current_markers)
}