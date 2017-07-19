library(shiny)
library(datasets)
library(ggplot2)
data(iris)
data <- iris

server<-(function(input, output) {
  
  # Create a reactive text
  text <- reactive({
    paste(input$variable, 'versus', input$variable2)
  })
  
  # Return as text the selected variables
  output$caption <- renderText({
    text()
  })
  
  # Generate a plot of the requested variables
  output$plot <- renderPlot({
    p <- ggplot(data, aes_string(x=input$variable, y=input$variable2, colour="Species")) + geom_point()
    print(p)
  })
})

library(datasets)
library(ggplot2)
ui<-shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Using Shiny with the iris dataset"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    selectInput("variable", "First variable:",
                list("Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width",
                     "Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width")),
    
    selectInput("variable2", "Second variable:",
                list("Sepal length" = "Sepal.Length",
                     "Sepal width"  = "Sepal.Width",
                     "Petal length" = "Petal.Length",
                     "Petal width"  = "Petal.Width"))
  ),
  #h3(textOutput("caption")),
  mainPanel(
    
    plotOutput("plot")
  )
))
