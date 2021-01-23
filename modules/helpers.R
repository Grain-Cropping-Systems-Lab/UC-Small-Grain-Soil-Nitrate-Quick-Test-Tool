update_tab <- function(id, triggerId, dashboardId, tab, parent
) {
	moduleServer(id,
							 function(input, output, session){
							 	observeEvent(triggerId(), {
							 		updateTabItems(parent, dashboardId, selected = tab)
							 	})
							 })
}