library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(datasets)

dataset <- ToothGrowth

ui <- fluidPage(
  fluidRow(
    
    column(width = 6,
           plotOutput("plot1", height = 350,
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           ),
           actionButton("exclude_toggle", "Toggle points"),
           actionButton("exclude_reset", "Reset")
    )
  )
)

server <- function(input, output) {
  # For storing which rows have been excluded
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow( dataset))
  )
  
  output$plot1 <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <-  dataset[ vals$keeprows, , drop = FALSE]
    exclude <-  dataset[!vals$keeprows, , drop = FALSE]
    
    ggplot(keep, aes(dose, len)) + geom_point() +
      geom_smooth(method = lm, fullrange = TRUE, color = "black") +
      geom_point(data = exclude, shape = 21, fill = NA, color = "black", alpha = 0.25) +
      coord_cartesian(xlim = c(0.5, 2.0), ylim = c(5,35))
  })
  
  # Toggle points that are clicked
  observeEvent(input$plot1_click, {
    res <- nearPoints( dataset, input$plot1_click, allRows = TRUE)
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints( dataset, input$plot1_brush, allRows = TRUE)
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Reset all points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow( dataset))
  })
  
}

shinyApp(ui, server)