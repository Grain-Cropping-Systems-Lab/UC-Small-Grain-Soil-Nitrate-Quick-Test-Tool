ui <- dashboardPage(
	dashboard_header_ui("header"),
	dashboardSidebar(disable = TRUE,
									 sidebarMenu(id = "tabs",
									 						menuItem("location", tabName = "location", icon = icon("dashboard"))
									 						
									 )
	),
	dashboardBody(
		tags$head(
			tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
			),
		tabItem(tabName = "location",
							fluidRow(
								column(6,
								box(title = "Location", solidHeader = TRUE, status = "primary", 
										width = 12, 
										p("Click or move the marker to the field where the soil sample was taken. You must choose a field within the agricultural lands of CA (non-shaded region)."),
										map_mod_ui("map_mod")
										),
								box(title = "Quick Test Value", solidHeader = TRUE, status = "primary",
										width = 12, 
									shinyWidgets::noUiSliderInput(
										inputId = "padvalue", 
										label = "Enter your pad value from the soil nitrate quick test (ppm). Results are based on top 0-12 in of soil.",
										color = "#005fae",
										value = NA,
										min = 0,
										max = 50,
										tooltips = TRUE,
										pips = list(
											mode = "values",
											values = c(0, 2, 5, 10, 20, 50),
											format = wNumbFormat(decimals = 0)
										),
										step = 0.5,
										format = wNumbFormat(decimals = 1)
									),
								radioButtons("cacl2", label = "", 
														 choices = list("Calcium Chloride used in shaking solution" = "cacl2", 
														 							 "Water-only used in shaking solution" = "water"), selected = "cacl2")
								)
								),
								column(6, 
								box(title = "Lab Value", solidHeader = TRUE, status = "primary",
										width = 12, 
										shinyWidgets::noUiSliderInput(
											inputId = "labvalue", 
											label = "Alternatively, if you have a lab value you may select it here. Results are based on nitrate-N (ppm) in the top 0-12 inches of soil (to translate nitrate to nitrate-N multiply by 0.23).",
											color = "#005fae",
											value = NA,
											min = 0,
											max = 50,
											tooltips = TRUE,
											pips = list(
												mode = "values",
												values = c(0, 10, 20, 30, 40, 50),
												format = wNumbFormat(decimals = 0)
											),
											step = 0.1,
											format = wNumbFormat(decimals = 1)
										)
								),
								box(width = 12, 
										title = "Bulk Density", solidHeader = TRUE, status = "primary",
									shinyWidgets::noUiSliderInput(
										inputId = "bulk_density", 
										label = HTML("The results are based on the in situ bulk density (g/cm<sup>3</sup>) from the SSURGO
database. Values used and presented here are a weighted average of the component types present in
the top 0-12 in of soil. SSURGO-estimated bulk density may not accurately represent the bulk density at a site. For better accuracy, update the SSURGO estimate with a recently-measured bulk density value."),
										color = "#005fae",
										value = 1.25,
										min = 0.5,
										max = 1.6,
										tooltips = TRUE,
										pips = list(
											mode = "values",
											values = c(0.5, 1, 1.5),
											format = wNumbFormat(decimals = 1)
										),
										step = 0.01,
										format = wNumbFormat(decimals = 2)
									),
									br(),
									bsButton("reset_bd", label = "Reset", icon("undo-alt"), block = TRUE, size = "lg")
								),
								box(title = "Soil Results", solidHeader = TRUE, status = "primary",
										width = 12, 
										htmlOutput("htmlout"), # use htmlOutput so can format the text to be bold, colored, etc.
										bsTooltip("htmlout", title = "The error provided shows the 95% confidence interval for the values shown.", placement = "top")
								),
								#column(6, offset = 6,
									"For more information on how to perform the soil nitrate quick test see",
									a("http://smallgrains.ucanr.edu/Nutrient_Management/snqt/", href="http://smallgrains.ucanr.edu/Nutrient_Management/snqt/")
							#	)
								
							)
	)
	)
)
)