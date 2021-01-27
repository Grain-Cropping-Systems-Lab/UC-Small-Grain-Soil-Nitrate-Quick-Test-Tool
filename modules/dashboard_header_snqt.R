dashboard_header_ui <- function(id, label = "header") {
	ns <- NS(id)
	dashboardHeader(title = "The Soil Nitrate Quick Test Web-Tool", titleWidth = 700,
									tags$li(actionLink(ns("open_info_modal"),
																		 label = "",
																		 icon = icon("info-circle")),
													class = "dropdown"))
}

dashboard_header_server <- function(id){
	moduleServer(
		id,
		function(input, output, session){
			observeEvent(input$open_info_modal, {
				showModal(
					modalDialog(title = "About the Soil Nitrate Quick Test Web-Tool",
											HTML("The Soil Nitrate Quick Test Web-Tool was first published in April 2020. It was last updated on: 1/27/2021."),
											br(), br(),
											HTML("The code base to reproduce this webtool publicly available at <a href = 'https://github.com/Grain-Cropping-Systems-Lab/UC-Small-Grain-Soil-Nitrate-Quick-Test-Tool' target='_blank'>https://github.com/Grain-Cropping-Systems-Lab/UC-Small-Grain-Soil-Nitrate-Quick-Test-Tool</a>."),
											br(), br(),
											HTML("A wide range of University of California Cooperative Extension and University of California, Davis personnel have contributed to the development of this information. The following individuals deserve credit for key contributions to the information presented here: Taylor Nelsen, Gabriel Rosa, Konrad Mathesius, Michael Rodriguez, Jessica Schweiger, Ethan McCullough, Taylor Becker, Nicholas Clark, Sarah Light, Michelle Leinfelder-Miles, Thomas Getts, Giuliano Galdi, Jessica Henriquex, Rozana Moe, Leah Puro, Jonathan Slocum, Eric Williams, Quinn Levin, Steven Spivak, Maria Sandate-Reyes, Serena Lewin, Ryan Byrnes, Jason Tsichlis, Katherine Mulligan, Darrin Culp, Steve Orloff, Steven Wright, Robert Hutmacher, Justin Merz, and Mark Lundy."),
											br(), br(),
											HTML("To cite this page, please use: Nelsen, T., Rosa, G., & Lundy, M. (2020, April 23). <i>The Soil Nitrate Quick Test Web-Tool.</i> Retrieved from http://smallgrain-n-management.plantsciences.ucdavis.edu/snqt/"),
											br(), br(),
											HTML("For questions about this content, please contact Mark Lundy, Assistant UC Cooperative Extension Specialist in Grain Cropping Systems (<a href = 'melundy@ucdavis.edu' target='_blank'>melundy@ucdavis.edu</a>) or one of the UCCE contacts listed at <a href = 'http://smallgrains.ucanr.edu/contact_us/' target='_blank'>http://smallgrains.ucanr.edu/contact_us/</a>")
					)
				)
			})
		}
	)
}