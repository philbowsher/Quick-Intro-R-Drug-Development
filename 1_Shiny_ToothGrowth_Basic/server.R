library(datasets)

function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- ToothGrowth
    if (input$supp != "All") {
      data <- data[data$supp == input$supp,]
    }
    data
  }))
  
}