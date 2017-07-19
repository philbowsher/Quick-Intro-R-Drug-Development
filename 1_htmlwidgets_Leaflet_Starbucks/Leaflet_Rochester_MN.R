download.file("https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv?accessType=DOWNLOAD",destfile="data.csv")

starbucks1 <- read.csv("data.csv")

View(starbucks1)

starbucks <- starbucks1[ which(starbucks1$State=='MN' 
                               & starbucks1$Country== 'US'), ]

View(starbucks)

library("leaflet") 

leaflet() %>% addTiles() %>% setView(-92.466751, 44.022673, zoom = 14) %>% 
  
  addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name)
