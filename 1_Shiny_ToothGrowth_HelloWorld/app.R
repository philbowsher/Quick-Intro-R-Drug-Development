library(shiny)

# n <- ToothGrowth

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("plotType", "Plot type",
                   c("Scatter"="p", "Line"="b")
      )
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output){
  
  output$plot <- renderPlot({
    plot(ToothGrowth$dose, ToothGrowth$len, type=input$plotType)
  })
  
  
}

shinyApp(ui = ui, server = server)