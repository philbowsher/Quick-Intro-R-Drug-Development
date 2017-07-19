library(datasets)
library(DT)

fluidPage(
  titlePanel("Basic DataTable for ToothGrowth"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("supp",
                       "Supplement:",
                       c("All",
                         unique(as.character(ToothGrowth$supp))))
    )
    )
  ,
  # Create a new row for the table.
  fluidRow(
    DT::dataTableOutput("table")
  )
)