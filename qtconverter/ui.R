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
								box(title = "Location", solidHeader = TRUE, status = "primary", 
										p("Click or move the marker to the field where the soil sample was taken. You must choose a field within the agricultural lands of CA (non-shaded region)."),
										map_mod_ui("map_mod")
										),
								box(title = "Quick Test Value", solidHeader = TRUE, status = "primary",
									shinyWidgets::noUiSliderInput(
										inputId = "padvalue", 
										label = "Enter your pad value from the soil nitrate quick test (ppm). Results are based on top 0-12 in of soil.",
										color = "#005fae",
										value = 10,
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
								),
								box(
										htmlOutput("htmlout"), # use htmlOutput so can format the text to be bold, colored, etc.
										bsTooltip("htmlout", title = "The error provided shows the 95% confidence interval for the values shown.", placement = "top")
									),
								box(
									shinyWidgets::noUiSliderInput(
										inputId = "bulk_density", 
										label = HTML("The results are based on the oven dry bulk density (g/cm<sup>3</sup>) from the SSURGO
database. Values used and presented here are a weighted average of the component types present in
the top 0-12 in of soil. Adjust the site-specific bulk density if needed."),
										color = "#005fae",
										value = 1.25,
										min = 0.5,
										max = 2.0,
										tooltips = TRUE,
										pips = list(
											mode = "values",
											values = c(0.5, 1, 1.5, 2),
											format = wNumbFormat(decimals = 1)
										),
										step = 0.01,
										format = wNumbFormat(decimals = 2)
									),
									br(),
									bsButton("reset_bd", label = "Reset", icon("undo-alt"), block = TRUE, size = "lg")
								),
								column(6, offset = 6,
									"For more information on how to perform the soil nitrate quick test see",
									a("http://smallgrains.ucanr.edu/Nutrient_Management/snqt/", href="http://smallgrains.ucanr.edu/Nutrient_Management/snqt/")
								)
								
							)
	)
	)
)