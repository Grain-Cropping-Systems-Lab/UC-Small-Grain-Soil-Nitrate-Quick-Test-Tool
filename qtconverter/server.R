server <- function(input, output, session) {

	dashboard_header_server("header")
	
	map_outputs <- map_mod_server("map_mod",
																shapefile_path = "../files/ca_ag_regions.shp",
																region_behavior = region_behavior_snqt,
																default_lat = 38.533867,
																default_lon = -121.771598)

	# soil data is pulled from the database and calculated from user input
	# values are reactive so they recalculate whenever there is new inputs
	soil_data <- reactive({
		if(!is.null(map_outputs$lon)){
		dbquery <- DBI::dbGetQuery(con, paste("SELECT muname, omr, dbthrd FROM grain.ssurgo WHERE ST_Contains(geom, ST_GeomFromText('POINT(", req(map_outputs$lon), req(map_outputs$lat), ")',4326));"))
		dbquery[,2] <- ifelse(!is.na(dbquery[,2]), as.numeric(dbquery[,2]), 1.01010101010101)
		return(dbquery)
		}
	})


	# output calculation values as text
	# organic soils are defined as > 5% organic matter average in the top 0-12 in
	observe({
		
		if(!is.null(map_outputs$lon)){
		
		soilqt <- qtconversion(padvalue = input$padvalue, bd = input$bulk_density, extractant = input$cacl2)
		
		output$htmlout <- renderText({

			if (soil_data()[, 2] != 1.01010101010101 & !is.na(map_outputs$lat)){
				if(soil_data()[,3] > 1.6 | soil_data()[,3] < 0.5){
					paste("<b><font color='red'>The bulk density at this location is outside of our observed range.</b></font>")
				} else {
				#soilqt <- qtconversion(padvalue = input$padvalue, bd = input$bulk_density, extractant = input$cacl2)
				paste("For the given field in <b>",
							DBI::dbGetQuery(con, paste("SELECT namelsad FROM grain.ca_counties WHERE ST_Contains(geom, ST_GeomFromText('POINT(", map_outputs$lon, map_outputs$lat, ")',4326));"))$namelsad, "</b> <br>",
							"that has a soil type of <b>", soil_data()[, 1], "</b> <br>",
							"which is a <b>", ifelse(as.numeric(soil_data()[, 2]) > 5, "organic soil", "mineral soil"), "</b>",
							"with an approximate bulk density of <b>", input$bulk_density, "g/cm<sup>3</sup> </b> <br>",
							"with a pad value of <b>", input$padvalue, "</b> <br>",
							"tested with <b>", ifelse(input$cacl2 == "water", "water", "Calcium Chloride"), "</b>",
							"the lab ", ifelse(input$nform == "nitraten", "nitrate-N", "nitrate"), 
							" equivalent is <b> <font color='red'>", input$labvalue, "ppm &plusmn;",
							round(mean(soilqt[, 3] - input$labvalue, input$labvalue - soilqt[, 1]), 1), "</b> </font> <br>",
							"and the approximate nitrate-N fertilizer equivalent in the soil tested is <b> <font color='red'>",
							round(input$labvalue*(43560*as.numeric(input$bulk_density)*62.428/1000000), 0),
							"N lb/ac &plusmn;",
							round((mean(soilqt[, 3] - input$labvalue, input$labvalue - soilqt[, 1]))*(43560*as.numeric(input$bulk_density)*62.428/1000000), 0), "</b> </font>")
				}

			} else {
				paste("<b><font color='red'>There is no soil data.</b></font>")

			}

		})
		
		
		
		}

	})
	
	observe({
		updateNoUiSliderInput(session, "bulk_density", value = round(as.numeric(soil_data()[,3]), 2))
	})

	observeEvent(input$reset_bd, {
		updateNoUiSliderInput(session, "bulk_density", value = round(as.numeric(soil_data()[,3]), 2))
	})
	
	observeEvent(input$padvalue, {
		soilqt <- qtconversion(padvalue = input$padvalue, bd = input$bulk_density, extractant = input$cacl2)
		if(round(soilqt[, 2], 1) != input$labvalue){
		updateNoUiSliderInput(session, "labvalue", value = round(soilqt[, 2], 1))
		}
			
	})
	
	observeEvent(input$bulk_density, {
		soilqt <- qtconversion(padvalue = input$padvalue, bd = input$bulk_density, extractant = input$cacl2)
		updateNoUiSliderInput(session, "labvalue", value = round(soilqt[, 2], 1))
	})
	
	observeEvent(input$labvalue, {
		labval <- reverse_qtconversion(labvalue = input$labvalue,
																	 bd = input$bulk_density,
																	 extractant = input$cacl2)
		if(labval != input$padvalue){
			updateNoUiSliderInput(session, "padvalue",
														value = labval)
		}
	})

}
