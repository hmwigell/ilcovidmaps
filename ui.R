#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(leaflet)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("cosmo"),
                  tags$head(includeHTML("google-analytics.html"),
                      tags$style(HTML("
                      @media only screen and (max-width: 600px) {
                        body {
	                        padding-left: 20px !important ;
	                        padding-right: 20px !important ;
                        }
                      }
                      body {
                      	padding-left: 90px;
                      	padding-right: 90px;
                      }"))),
                  fluidRow(column = 12,
                    titlePanel("Increase in COVID-19 Cases from April 21st to May 5th by Zip Code, Illinois"),
                    sidebarLayout(
                      position = "right",
                      sidebarPanel(
                      HTML("<p>This map was created using data from the Illinois Department of Public Health, which can 
                      be viewed <a href=\"http://www.dph.illinois.gov/covid19/covid19-statistics\">here.</a> I found 
                      archived versions of the page using 
                      <a href=\"https://web.archive.org/web/*/http://www.dph.illinois.gov/sitefiles/COVIDZip.json?nocache=1\">Wayback Machine</a> 
                      and used the data to find two week increases by zip code between April 21st and May 5th.</p>
                 
                     <p>The largest increases in cases were in: 
                     <ol>
                     <li>60623, up 1075 (from 521 to 1596)</li>
                     <li>60639, up 1022 (from 568 to 1590)</li>
                     <li>60629, up 955 (from 551 to 1506)</li>
                     <li>60632, up 937 (from 453 to 1390)</li>
                     <li>60804, up 923 (from 433 to 1356)</li>
                     </ol>
                     </p>")),

                    mainPanel(
                      leafletOutput("mymap")))),
                  fluidRow(column = 12,
                  titlePanel("Percent of Positive Tests by Zip Code"),

                  sidebarLayout(
                    position = "left",
                    sidebarPanel(
                    HTML("<p>As noted in this <a href=\"https://www.npr.org/sections/coronavirus-live-updates/2020/03/30/824127807/if-most-of-your-coronavirus-tests-come-back-positive-youre-not-testing-enough\">NPR article</a>, 
                    ideally, about 10% of tests should come back positive. </p> <p><i>In communities where most 
                    coronavirus tests are coming back positive, it's a sign there are many more cases there that 
                    haven't been found, say World Health Organization officials in a press conference on Monday.</i></p>
                 
                    <p>The most tests coming back positive is in: 
                    <ol>
                   <li>60434, with 134 cases and 72 tests (likely reported incorrectly), >100%</li>
                   <li>62204, with 30 cases and 50 tests, 60%</li>
                   <li>60085, with 1251 cases and 2282 tests, 55%</li>
                   <li>60064, with 334 cases and 612 tests, 55%</li>
                   <li>62090, with 7 cases and 13 tests, 54%</li>
                   <li>60088, with 34 cases and 68 tests, 50%</li>
                   </ol></p>")),
                    mainPanel(
                      leafletOutput("map2")))),
                  fluidRow(column = 12,
                           titlePanel("Cases per 100k Residents as of May 6th"),
                           sidebarLayout(
                             position = "right",
                             sidebarPanel(
                             HTML("<p>Updated numbers as of May 6th</p> 
                             <p>The most cases per 100k are in: 
                             <ol>
                             <li>62272, 3082/100k, 41 cases total</li>
                             <li>62992, 2754/100k, 19 cases total</li>
                             <li>60064, 2402/100k, 350 cases total</li>
                             <li>60141, 2143/100k, 6 cases total</li>
                             <li>60623, 2059/100k, 1663 cases total</li>
                             </ol></p>")),
                             mainPanel(leafletOutput("map3")))),
                  fluidRow(column = 12,
                  HTML("<p><b>As noted on the website of the Illinois Department of Health, the source of this 
                  data:</b> The data on this site is what has been entered into Illinois' National Electronic 
                  Disease Surveillance System (I-NEDSS) data system. The data is constantly being entered and 
                  may change as cases are investigated.  Therefore, numbers may vary from other sites where 
                  data is published. *Data shown is >5 cases per zip code which is consistent with Collection, 
                  Disclosure, and Confidentiality of Health Statistics (77 Ill. Adm. Code 1005). It should be 
                  assumed that COVID-19 exposure can occur in every county in IL.Zip code is zip code of 
                  residence, which may not be location of exposure.</p>")),
                  
                  fluidRow(column = 12,
                  HTML("<b>Creator + Contact Info</b> <p>This map was created Patrycja Gorska. I'm from Hickory Hills, 
                  IL, and I'm a rising senior at Yale majoring in computer science + completing a certificate in data 
                  science. You can contact me on <a href=\"https://www.linkedin.com/in/pgorska/\">LinkedIn</a> if you
                  have any questions.</p>
                  <p>I'll be adding more maps to show the increase in cases and percent of tests coming back positive 
                  in the next few days, as well as the datasets I created from the Illinois DPH data. </p>")
                  )
        )
)
