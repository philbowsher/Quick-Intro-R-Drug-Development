library(shiny)

Screening <- read.csv("Sample_ADA_Data_05062017_Screening.csv", header=TRUE, sep=",")

ui <- htmlTemplate(filename = "index.html",
                   radio = radioButtons("plotType", "Density / Freq?",
                                c("densities"="FALSE", "frequencies"="TRUE")),
                   plot = plotOutput("hist")
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    hist(Screening$Signal_Response_No_Drug, # histogram
         col = "peachpuff", # column color
         border = "black", 
         prob = input$plotType, # show densities instead of frequencies
         xlab = "Signal_Response_No_Drug",
         main = "Screening")
    lines(density(Screening$Signal_Response_No_Drug), # density plot
          lwd = 2, # thickness of line
          col = "chocolate3")
    abline(v = mean(Screening$Signal_Response_No_Drug),
           col = "royalblue",
           lwd = 2)
    abline(v = median(Screening$Signal_Response_No_Drug),
           col = "red",
           lwd = 2)
    legend(x = "topright", # location of legend within plot area
           c("Density plot", "Mean", "Median"),
           col = c("chocolate3", "royalblue", "red"),
           lwd = c(2, 2, 2))
  })
}

shinyApp(ui = ui, server = server)