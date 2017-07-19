library(datasets)
library(ggplot2)

function(input, output) {
  
  dataset <- reactive({
    ToothGrowth[sample(nrow(ToothGrowth), input$sampleSize),]
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
    
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
    if (input$jitter)
      p <- p + geom_jitter()
    if (input$smooth)
      p <- p + geom_smooth()
    
    print(p)
    
  })
  
  # -------------------------------------------------------------------
  # Linked plots (middle and right)
  
  dataset2 <- ToothGrowth
  
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow( dataset2))
  )
  
  output$plot1 <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <-  dataset2[ vals$keeprows, , drop = FALSE]
    exclude <-  dataset2[!vals$keeprows, , drop = FALSE]
    
    ggplot(keep, aes(dose, len)) + geom_point() +
      geom_smooth(method = lm, fullrange = TRUE, color = "black") +
      geom_point(data = exclude, shape = 21, fill = NA, color = "black", alpha = 0.25) +
      coord_cartesian(xlim = c(0.5, 2.0), ylim = c(5,35))
  })
  
  # Toggle points that are clicked
  observeEvent(input$plot1_click, {
    res <- nearPoints( dataset2, input$plot1_click, allRows = TRUE)
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints( dataset2, input$plot1_brush, allRows = TRUE)
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Reset all points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow( dataset2))
  })
  
}
