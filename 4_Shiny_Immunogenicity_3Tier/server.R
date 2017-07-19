#Required libraries
library(shiny)
library(dplyr)
#library(reshape)
#library(stringr)
library(plotly)
#library(data.table)
#library(rpart)
#library(xtable)
library(EnvStats)

shinyServer(function(input, output, session) {
  
  #Input the screening data _______________________________________
  screeningData <- reactive ({
    
    inFile1 <- input$file1
    
    if (is.null(inFile1))
      return(NULL)
    
    read.csv(inFile1$datapath, header=TRUE, sep=",")
    
  })
  
  
  
  
  #Input the confirmatory ______________________________________________
  confirmatoryData <- reactive ({
    
    inFile2 <- input$file2
    
    if (is.null(inFile2))
      return(NULL)
    
    read.csv(inFile2$datapath, header=TRUE, sep=",")
    
  })
  
  
  
  #Input titer ___________________________________________
  titerData <- reactive ({
    
    inFile3 <- input$file3
    
    if (is.null(inFile3))
      return(NULL)
    
    #Read input file
    read.csv(inFile3$datapath, header=TRUE, sep=",")
    
  })
  
  
  # Next part, data wrangling via dplyr
  
  
  #Add Log10 screening to ALL screening data ___________________________________________
  screening_cp_np_log <- reactive ({
    
    if (is.null(screeningData()))
      return(NULL)
    
      
    df <- screeningData() %>% mutate(Screening_Cutpoint = input$screening_cutpoint) %>% 
      mutate(Signal_Response_No_Drug_log10 = log10(Signal_Response_No_Drug))
    
    df <- data.frame(df)
    
  })
  
  
  
  #Add CP and Pos Neg to screening and only keep screening ___________________________________________
  screening_cp_np <- reactive ({
    
    if (is.null(screeningData()))
      return(NULL)
    
      
    df <- screeningData() %>% mutate(Screening_Cutpoint = input$screening_cutpoint) %>%
      mutate(Screening_Result_Drug = ifelse(Signal_Response_No_Drug > Screening_Cutpoint, "Positive", "Negative")) %>% 
      filter(Screening_Result_Drug=="Positive")%>% mutate(Signal_Response_No_Drug_log10 = log10(Signal_Response_No_Drug))
    
    df <- data.frame(df)
    
  })
  
  
  #Add confirmatory data to pos screening and calc Percent_Signal_Inhibition_Drug and find NP ____________________
  confirmatory_cp_np <- reactive ({
    
    if (is.null(confirmatoryData()))
      return(NULL)
    
    #Get copy of input data  
    df <- confirmatoryData()
    
    joindf <- screening_cp_np() %>% left_join(confirmatoryData(), by = 'Sample_Number')
    
    df <- joindf %>%
      mutate(Signal_Response_Difference = Signal_Response_No_Drug - Signal_Response_Drug)  %>% mutate(Signal_Response_Divide = Signal_Response_Difference / Signal_Response_No_Drug)  %>%
      mutate(Percent_Signal_Inhibition_Drug = Signal_Response_Divide * 100) %>% mutate(Confirmatory_Cutpoint = input$confirmatory_cutpoint) %>%
      mutate(Confirmatory_Result_Drug = ifelse(Percent_Signal_Inhibition_Drug > Confirmatory_Cutpoint, "Positive", "Negative")) %>% select(-Signal_Response_Difference, -Signal_Response_Divide)
    
    df <- data.frame(df)
    
  })
  
  
  #Add titer to screening and confiratory data for reporting with P _________________________________
  titer_confirmatory <- reactive ({
    
    if (is.null(titerData()))
      return(NULL)
    
    #Get copy of input data  
    df <- titerData()
    
    df <- confirmatory_cp_np() %>% left_join(titerData(), by = 'Sample_Number')
    
    
    df <- data.frame(df)
    
    
    
  })
  
  
  #True Positives from confirmatory tier _____________________
  true_positives <- reactive ({
    
    
    if (is.null(titerData()))
      return(NULL)
    
    #Get copy of input data  
    df <- titer_confirmatory() %>% filter(Confirmatory_Result_Drug=="Positive")
    
    
    df <- data.frame(df)
    
  })
  
  
  #File Download Button for true positives __________________
  output$downloadData1 <- downloadHandler(
    
    filename = function() {file = paste('true_positives','-',Sys.Date(),'.csv', sep = '')},
    content = function(file) {
      write.csv(true_positives(), file, row.names = FALSE)
    })
  
  
  # Show the screening data which are only pos if cutpoint is > then 0 ______________________
  output$screening <- DT::renderDataTable({
    DT::datatable(screening_cp_np(),
                  options = list(pageLength = 10, searching = FALSE),
                  rownames = FALSE)
  })
  
  
  # Show the confirmatory data - will be neg and pos from confirm ________________
  output$confirmatory <- DT::renderDataTable({
    DT::datatable(confirmatory_cp_np(),
                  options = list(scrollX = TRUE, pageLength = 10, searching = FALSE),
                  rownames = FALSE)
  })
  
  
  # Show the titer data - will be neg and pos from confirm ____________________
  output$titer <- DT::renderDataTable({
    DT::datatable(titer_confirmatory(),
                  options = list(scrollX = TRUE, pageLength = 10, searching = FALSE),
                  rownames = FALSE)
  })
  
  
  # Show only the true pos from confirm ____________________________
  output$truepositives <- DT::renderDataTable({
    DT::datatable(true_positives(),
                  options = list(scrollX = TRUE, pageLength = 10, searching = FALSE),
                  rownames = FALSE)
  })
  
  
  #Output plot neg pos of confirm with titer _________________________
  output$plot <- renderPlotly({
    
    if (is.null(titerData()))
      return(NULL)
    
    p <- qplot(Signal_Response_No_Drug, Percent_Signal_Inhibition_Drug, data=true_positives(), colour=Screening_Result_Drug)
    
    p <- ggplotly(p)
    
    p
    
    
  })
  
  
  #Output plot pos of screening and only show if tier 3 titer is loaded _________________________
  output$plot2 <- renderPlotly({
    
    if (is.null(titerData()))
      return(NULL)
    
    p2 = ggplot(screening_cp_np(), aes(x=screening_cp_np()$Signal_Response_No_Drug)) + geom_histogram(aes(y = ..density..), binwidth=density(screening_cp_np()$Signal_Response_No_Drug)$bw) + geom_density(fill="red", alpha = 0.2)
    
    p2 = ggplotly(p2)
    
    p2
    
  })
  
  
  #Show plotly hover _________________________
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
  
  
  
  
  #Output plot pos and neg of screening and show dist of log 10 screening _________________________
  output$plot3 <- renderPlotly({
    
    if (is.null(screening_cp_np_log()))
      return(NULL)
    
    p3 = ggplot(screening_cp_np_log(), aes(x=screening_cp_np_log()$Signal_Response_No_Drug_log10)) +
      geom_histogram(aes(y = ..density..), binwidth=density(screening_cp_np_log()$Signal_Response_No_Drug_log10)$bw) +
      geom_density(fill="red", alpha = 0.2)
    
    p3 = ggplotly(p3)
    
    p3
    
  })
  
  #Show table of samples above percentile for all samples screening _________________________
  output$results <- renderPrint({
    
    if (is.null(screeningData()))
      return(NULL)
    
    (result.dat <- screeningData()[(screeningData()$Signal_Response_No_Drug >= quantile(screeningData()$Signal_Response_No_Drug, input$stDev)),1:4])
  
    
    })
  
  #Summary stats on all screening samples _________________________
  output$table <- renderPrint({
    
    if (is.null(screeningData()))
      return(NULL)
    
    summaryFull(screeningData()$Signal_Response_No_Drug)
    
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
})

