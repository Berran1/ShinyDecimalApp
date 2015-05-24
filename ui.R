# Beats Internet Time Predictor and French Revolutionary Calendar day converter
library(lubridate)

shinyUI(pageWithSidebar(
        headerPanel("Decimalise Your Time!"),
        sidebarPanel(
               h3("Choose a time"),
               p("Enter a time and date (from 2015) and then see the results converted to Swatch Internet Time 
and to a date in the French Revolutionary Calendar."),
                
                checkboxInput(inputId = "currTime", "Use Current Time from your System", value=FALSE),
                
               conditionalPanel("input.currTime == 0",
                                h4("Enter time and date manually:"),
                selectInput(inputId = "hour",
                            label = "Hour",
                            choices = c(0:23),
                            selected = hour(Sys.time())),
                selectInput(inputId="minutes",
                            label = "Minutes",
                            choices = c(0:59),
                            selected = minute(Sys.time())),
                dateInput('normDate', "Day and Month", value=date(), min = "2015-01-01", max="2015-12-31", 
                          format="D d M")
                ),
                
              
                       conditionalPanel("input.currTime",
                                h4("Current time is appearing as:"),
                                verbatimTextOutput("localTime")
               
               ),
                HTML('<input type="text" id="client_time" name="client_time" style="display: none;"> '),
               HTML('<input type="text" id="client_time_zone_offset" name="client_time_zone_offset" style="display: none;"> '),
                
               tags$script('
                           $(function() {
                           var time_now = new Date()
                           $("input#client_time").val(time_now.getTime())
                           $("input#client_time_zone_offset").val(time_now.getTimezoneOffset())
                           });    
                           ')
        ),
        mainPanel(
                tabsetPanel(type = "tabs", 
                            
                                     
                                     #verbatimTextOutput("inputBiel")), 
                            tabPanel("Swatch Internet Time",
                                    h4("The time used in CET is:"),
                                    verbatimTextOutput("onlyTime"),
                                     h4("The time in Swatch Internet Time .beats is:"), 
                                     verbatimTextOutput("beats")),
                            tabPanel("French Revolutionary Time",
                                    h4("The date used is:"),
                                        verbatimTextOutput("onlyDate"),
                                     h4("which in the French Revolutionary Calendar is:"),
                                     p("day of the week:"),
                                     verbatimTextOutput("frenchDay"),
                                     p("day of the month:"),
                                     verbatimTextOutput("frenchDie"),
                                     p("month:"),
                                     verbatimTextOutput("frenchMonth")),
                            tabPanel("Methods and Explanation", 
                                     h3("Brief Explanation"),
                                     p("This app enables conversion to two sorts of (largely unused) decimal time forms.
The first, Swatch Internet Time, converts time within each day to 1000th of the day. 

The second, French Republican Calendar time, converts the days based on a year that starts at the equinox, around 22nd September,
and consists of regular 30-day months (+ 5 'complimentary days'
at year end) each of 3 10-day weeks.

You never know when you might need to find out your birthday in French Revolutionary time, for example!"),
                                     
                                     h3("Sources:"),
                                     h4("The main source for Swatch Internet Time is:"),
                                             a("http://en.wikipedia.org/wiki/Swatch_Internet_Time"),
                                     h4("and the main source for French Revolutionary Calendar is:"),
                                        a("http://en.wikipedia.org/wiki/French_Republican_Calendar"),
                                        p("with some simplifications made to avoid leap years etc."),
                                     p("and this stackoverflow post helped a lot with getting local times. maybe."),
                                     a("http://stackoverflow.com/questions/24842229/how-to-retrieve-the-clients-current-time-and-time-zone-when-using-shiny")
                                     
                                     )
                            )
                                            

        ))
)