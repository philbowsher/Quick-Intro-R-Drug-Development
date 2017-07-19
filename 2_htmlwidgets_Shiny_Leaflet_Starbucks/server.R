library(shiny)
library(leaflet)

# Preprocess (runs once) --------------------------------------------------

shinyServer(
  function(input, output) {
    output$map <- renderLeaflet({
      
      # Dynamically select only the points corresponding to the city
      # we want explore
      sub_i <- data[data$City == input$city,]
      
      # Dyniamically select the ownership type
      check_licensed <- any(grepl("Li", input$checkgroup))
      check_owned <- any(grepl("CO", input$checkgroup))
      if(check_licensed && check_owned) sub <- sub_i
      else if(check_licensed) sub <- sub_i[sub_i$Ownership.Type == "Licensed",]
      else if(check_owned) sub <- sub_i[sub_i$Ownership.Type == "Company Owned",]
      
      # Using leaflet to create the map
      leaflet() %>% addTiles()  %>% 
        addMarkers(data = sub, 
                   lat = ~ Latitude, 
                   lng = ~ Longitude, 
                   popup = paste("State:", sub$State, "<br>",
                                 "Address:", sub$Street.Address, "<br>",
                                 "Phone.Number", sub$Phone.Number))
      
    })
  })