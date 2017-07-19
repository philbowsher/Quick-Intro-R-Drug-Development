#Required library
library(plotly)
library(shinydashboard)

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    
    numericInput("screening_cutpoint", "Enter Screening Cutpoint",0),
    
    fileInput('file1', 'Input File for Screening Data',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv')),
    tags$hr(),
    
    numericInput("confirmatory_cutpoint", "Enter Confirmatory Cutpoint",0),
    
    fileInput('file2', 'Input File for Confirmatory',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv')),
    
    tags$hr(),
    

    fileInput('file3', 'Input File for Titer',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv')),
    

    tags$hr(),
    
    
    downloadButton('downloadData1', 'True Positives'),
    
    tags$hr(),
    
    downloadButton('downloadData2', 'All Results'),
    
    tags$hr(),
    
    downloadButton('downloadData3', 'Top 1000'),
    
    tags$hr()
    
  ))

body <- dashboardBody(tags$head
                      (tags$style(HTML                               #CSS Rules: Hash (#) is CLASS & period (.) is ID 
                                  ('
                                    .sidebar-menu>li>a               
                                    {padding: 0px 5px 0px 5px;  #top, right, bottom, left
                                    }
                                    #Table1
                                    {text-align:center;
                                    }
                                    #downloadData1
                                    {width: 130px;
                                    height: 35px;
                                    font-size: 16px;
                                    margin-left:50px;
                                    margin-top: 20px;
                                    margin-bottom: 20px;
                                    color: #fffff;
                                    background-color: #367fa9;
                                    border: #000000;
                                    padding-right: 12px;
                                    padding-top: 8px;
                                    }
                                    #downloadData2
                                    {width: 130px;
                                    height: 35px;
                                    font-size: 16px;
                                    margin-left:50px;
                                    margin-top: 20px;
                                    margin-bottom: 20px;
                                    color: #fffff;
                                    background-color: #367fa9;
                                    border: #000000;
                                    padding-right: 12px;
                                    padding-top: 8px;
                                    }
                                    #downloadData3
                                    {width: 130px;
                                    height: 35px;
                                    font-size: 16px;
                                    margin-left:50px;
                                    margin-top: 20px;
                                    margin-bottom: 20px;
                                    color: #fffff;
                                    background-color: #367fa9;
                                    border: #000000;
                                    padding-right: 12px;
                                    padding-top: 8px;
                                    }
                                    .form-group.shiny-input-container
                                    {width: 250px;
                                    margin-bottom: 10px;
                                    }
                                    '))),
  
                        tabsetPanel(type = "tabs",
                                      tabPanel(h4("Tier1: Screening Inputs"),
                                             DT::dataTableOutput("screening")),
                                      tabPanel(h4("Tier2: Confirmatory Inputs"),
                                             DT::dataTableOutput("confirmatory")),
                                      tabPanel(h4("Tier3: Titer Inputs"),
                                             DT::dataTableOutput("titer")),
                                      tabPanel(h4("True Positives"),
                                             DT::dataTableOutput("truepositives")),
                                      tabPanel(h4("Plots"),
                                               
                                               box(title = "Histogram", status = "primary", plotlyOutput("plot", height = 250)),
                                               box(title = "Histogram2", status = "success", plotlyOutput("plot2", height = 250)),
                                               box(title = "Clicked", status = "info", verbatimTextOutput("event"))
                                              ),
                                               
                                      tabPanel(h4("Aggregated Data Histogram"),
                                               sliderInput("stDev", "Specify the percentile value to select positive samples?", min = 0, max = .99, value = .95, step = .05),
                                               box(title = "Histogram", status = "primary", plotlyOutput("plot3", height = 250)),
                                               verbatimTextOutput("results"),
                                               verbatimTextOutput("table")),
                                      tabPanel(h4("All Results"),
                                             DT::dataTableOutput("allresults")),
                                      tabPanel(h4("Top 1000"),
                                             DT::dataTableOutput("top1000"))
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                               ))
ui <- dashboardPage(
  
  dashboardHeader(title = strong("IMMUNOGENICITY")),
  sidebar,
  body
  
)

    