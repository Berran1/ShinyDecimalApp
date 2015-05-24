library("lubridate")

# getting client time based on server and converting to CET

client_time <- function(x,y) {
        timeSecs <- as.numeric(x) / 1000 # in s
        timeOffset <- as.numeric(y) * 60 # in s
        timeFull <- timeSecs+timeOffset
        locTime1 <-  ymd_hms(as.character(.POSIXct(timeSecs)))
        locTime <- gsub(" UTC", "", as.character(locTime1))
      print(locTime)
}

biel_time <- function(x,y) {
        timeSecs <- as.numeric(x) / 1000
        timeOffset <- as.numeric(y) * 60 # in s
        timeFull <- timeSecs+timeOffset
        newTime2 <- ymd_hms(as.character(.POSIXct(timeFull)))
        newTime3 <- with_tz(newTime2, tzone = "Africa/Algiers")

}



# Setting up function to identify month and day of month of french revolutionary calendar
startday <- ymd("2014-09-22", tz = "Africa/Algiers")
monthtimes <- c(0,rep(30, 12), rep(1, 5), rep(30, 4)) # 30 day months, 5 extra days at end of "year"
durationFMonths <- ddays(cumsum(monthtimes))
enddays <- startday+durationFMonths
monthInts <- int_diff(enddays)
RevoMonths <- c("Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse",
                "Germinal", "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor", 
                "La Fête de la Vertu", "La Fête du Génie", "La Fête du Travail", "La Fête de l'Opinion",
                "La Fête des Récompenses") # leaving out 366th day
weekdays <- c(rep(rep(c("Primidi", "Duodi", "Tridi", "Quartidi", "Quintidi", "Sextidi", "Septidi", "Octidi",
                        "Nonidi", "Décadi"),3),12), rep("jours complémentaires", 5), 
              rep(rep(c("Primidi", "Duodi", "Tridi", "Quartidi", "Quintidi", "Sextidi", "Septidi", "Octidi",
                        "Nonidi", "Décadi"),3),4)) # 10-day weeks including the 5 year end days
#identifying interval of x. 
frenchify <- function(x) {
        test2 <- x %within% monthInts #check within which interval x lies
        monthday <- as.numeric(difftime(x,int_start(monthInts), units="days")) #x diff from interval start for all intervals
        class(monthday)
        monthday
        frenchtime <- data.frame(cbind(test2, RevoMonths, monthday))
        frenchtime[,2] <- as.character(frenchtime[,2])
        frenchtime[,3] <- ceiling(as.numeric(as.character(frenchtime[,3])))
        result <- frenchtime[frenchtime$test2 ==TRUE, 2:3]
}
        


shinyServer(
        function(input, output) {
                #identify date, either current or manually entered
                dateInput <- reactive({
                        if(input$currTime) {
                          
                          timeDate <- biel_time(input$client_time, input$client_time_zone_offset)
                        } else {
                                tt <- paste(input$normDate, input$hour, input$minutes, sep=".")
                                timedate <- strptime(tt, "%Y-%m-%d.%H.%M", tz="Africa/Algiers")
                        }
                                
                })
                localTime <- reactive({
                        if(input$currTime == TRUE) {
                                client_time(input$client_time, input$client_time_zone_offset)
                        }
                })
                #apply the date to conversions
                revTime <- reactive({
                        frenchify(dateInput())
                })
                revDow <- reactive({
                        weekdays[dateInput()-startday]
                })

                
                output$localTime <- renderPrint({localTime()})

                       
        output$inputDate <- renderPrint({dateInput()})
       
      # isolate time and date of date entered
       output$onlyTime <- renderPrint({format(dateInput(), "%H:%M:%S")})
        output$onlyDate <- renderPrint({format(dateInput(), "%A, %d %b")})
       # swatch internet time work
       output$beats <- renderPrint({
               beatsOfficial <- 
                       floorX <- floor_date(dateInput(), unit="day")
               secsX <- as.numeric(difftime(dateInput(), floorX, unit = "secs"), units = "secs")
               round(secsX/86.4, 2)})
      #FRC outputs  
      output$frenchDay <- renderPrint({revDow()})
        output$frenchMonth <- renderPrint({revTime()[,1]})
        output$frenchDie <- renderPrint({revTime()[,2]})
       #output$frenchTime <- renderPrint({fTime()})

              
        }
        
)