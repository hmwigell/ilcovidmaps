#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(leaflet)
library(tigris) 
options(tigris_use_cache = TRUE)
library(jsonlite)
library(dplyr)



confirmed <- read.csv("confirmed.csv")
# data for map1
doubles <- confirmed[names(confirmed) %in% c("zip", "primary_city", "X2020.05.05", "X2020.04.21")]
names(doubles) <- c("apr20", "may4","city", "zipcode")
doubles$increase <- doubles$may4 - doubles$apr20
doubles <- doubles[order(doubles$increase),]
map1 <- doubles[names(doubles) %in% c("zipcode", "city","apr20", "may4", "increase")]
names(map1) <- c("apr20", "may4","city", "zipcode",  "increase")
# data for map2
r2 <- read.csv("percentSick.csv")
map2 <- r2[names(r2) %in% c("zip", "X2020.05.05", "county", "primary_city")]
names(map2) <- c("today", "county", "city", "zipcode")
map2[is.na(map2)] <- 0
map2[map2$zip == 60434,]$today <- 1
map2$today <- map2$today * 100
# data for map3
today <- confirmed[names(confirmed) %in% c("zip", "primary_city", "X2020.05.06", "population_2015")]
names(today) <- c("t", "pop", "city", "zipcode")

char_zips <- zctas(cb = TRUE, starts_with = "6")
char_zips_tests <- char_zips
char_zips_today <- char_zips

char_zips <- geo_join(char_zips, map1, by_sp = "GEOID10", by_df = "zipcode", how = "left")
char_zips <- char_zips[char_zips$zipcode %in% map1$zipcode,]

char_zips_today <- geo_join(char_zips_today, today, by_sp = "GEOID10", by_df = "zipcode", how = "left")
char_zips_today <- char_zips_today[char_zips_today$zipcode %in% map1$zipcode,]
char_zips_today$sick100k <- as.numeric(char_zips_today$t / char_zips_today$pop) * 100000


char_zips_tests <- geo_join(char_zips_tests, map2, by_sp = "GEOID10", by_df = "zipcode", how = "left")
char_zips_tests  <- char_zips_tests[char_zips_tests$zipcode %in% map1$zipcode,]




shinyServer(function(input, output) {
    
    output$mymap <- renderLeaflet({
        
        pal <- colorNumeric(
            palette = "Reds",
            domain = char_zips@data$increase, n = 7)
        
        labels <- 
            paste0(
                char_zips@data$city, ", ",
                char_zips@data$GEOID10, "<br/>",
                "Cases on April 21th: ",
                char_zips@data$apr20, "<br/>",
                "Cases on May 5th: ", 
                char_zips@data$may4, "<br/>",
                "New cases: ",
                char_zips@data$increase) %>%
            lapply(htmltools::HTML)
        
        
        char_zips %>% 
            leaflet %>%  
            setView(-88, 41.8, 8)  %>% 
            # add base map
            addProviderTiles("CartoDB") %>% 
            #setView(41.853890, -87.883712, zoom = 8.25) %>% 
            # add zip codes
            addPolygons(fillColor = ~pal(increase),
                        weight = 1,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.8,
                        highlight = highlightOptions(weight = 2,
                                                     color = "#666",
                                                     dashArray = "",
                                                     fillOpacity = 0.7,
                                                     bringToFront = TRUE),
                        label = labels)  %>% 
            # add legend
            addLegend(pal = pal, 
                      values = ~increase, 
                      opacity = 0.7, 
                      title = htmltools::HTML("Increase in<br> 
                                    COVID-19 <br> 
                                    cases by <br>zip code"),
                      position = "bottomright") 
    })
    
    output$map2 <- renderLeaflet({
        
        pal2 <- colorNumeric(
            palette = "Reds",
            domain = char_zips_tests@data$today)
        
        labels2 <- 
            paste0(
                char_zips_tests@data$city, ", ",
                char_zips_tests@data$GEOID10, "<br/>",
                "Percent positive tests: ",
                round(char_zips_tests@data$today, 2), "% <br/>") %>%
            lapply(htmltools::HTML)
        
        
        char_zips_tests %>% 
            leaflet %>%  
            setView(-88, 41.8, 8)  %>% 
            # add base map
            addProviderTiles("CartoDB") %>% 
            # add zip codes
            addPolygons(fillColor = ~pal2(today),
                        weight = 1,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.8,
                        highlight = highlightOptions(weight = 2,
                                                     color = "#666",
                                                     dashArray = "",
                                                     fillOpacity = 0.7,
                                                     bringToFront = TRUE),
                        label = labels2)  %>% 
            # add legend
            addLegend(pal = pal2, 
                      values = ~today, 
                      opacity = 0.7, 
                      title = htmltools::HTML("Percent of<br> 
                                    tests positive <br>"),
                      position = "bottomright") 
    })
    
    output$map3 <- renderLeaflet({
        
        pal3 <- colorNumeric(
            palette = "Reds",
            domain = char_zips_today@data$sick100k)
        
        labels3 <- 
            paste0(
                char_zips_today@data$city, ", ",
                char_zips_today@data$GEOID10, "<br/>",
                "Cases per 100k: ",
                round(char_zips_today@data$sick100k, 2), "<br/>",
                "Total cases: ",
                char_zips_today@data$t) %>%
            lapply(htmltools::HTML)
        
        
        char_zips_today %>% 
            leaflet %>%  
            setView(-88, 41.8, 8)  %>% 
            # add base map
            addProviderTiles("CartoDB") %>% 
            # add zip codes
            addPolygons(fillColor = ~pal3(sick100k),
                        weight = 1,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.8,
                        highlight = highlightOptions(weight = 2,
                                                     color = "#666",
                                                     dashArray = "",
                                                     fillOpacity = 0.7,
                                                     bringToFront = TRUE),
                        label = labels3)  %>% 
            # add legend
            addLegend(pal = pal3, 
                      values = ~sick100k, 
                      opacity = 0.7, 
                      title = htmltools::HTML("COVID-19 cases<br> 
                                    per 100k<br>"),
                      position = "bottomright") 
    })
    
})



