qt_lme_model <- readRDS("../files/qt_lme_model.rds")

qtconversion <- function(padvalue = 0, extractant, bd){
	
	custom_list <- list(amount = padvalue, 
											dbvndr = bd, 
											measurement_device = ifelse(extractant == "water",
																									"WaterWorks Nitrate/Nitrite test strips, dry soil, H2O",
																									"WaterWorks Nitrate/Nitrite test strips, dry soil, CaCl2"))
	
	response <- data.frame(emmeans::emmeans(qt_lme_model, ~ amount, at=custom_list, type = "response", data = qt_lme_model$data))
	
	return(data.frame(lower = response$lower.CL, amount = response$response, upper = response$upper.CL))
	
}
