library(magrittr)
library(httr)
library(rvest)
library(stringr)
library(reshape2)
library(knitr)
library(ggplot2)
library(plotly)
Sys.setlocale(category = "LC_ALL", locale = "cht")
getDataformCWB <- function(station, timerange1, timerange2, iterm){
  # ---------- input Targat Station ---------- #
  # Load Station List
  stationList <- read.csv("data/new_Station_a_List.csv")
  inputStationName <- c(station) # "Location"
  # ---------- input Date ---------- #
  fromdate <- as.Date(timerange1) # "2017-01-06"
  todate <- as.Date(timerange2) # "2017-01-06"
  date <- seq.Date(fromdate, todate, "day")
  lengthDate <- as.numeric(length(date))
  lengthDatep <- as.numeric(lengthDate+1)
  # ---------- URL ---------- #
  url_1 <- "http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station="
  url_2 <- "&stname=%25E7%25AB%25B9%25E6%259D%25B1&datepicker="
  url_1_1 <- paste(url_1, stationList$id, sep = "")
  url_all <- paste(url_1_1, url_2, sep = "")
  stationListnew <- cbind(stationList, url_all)
  substation <- data.frame(subset(stationListnew, stationListnew$engName == inputStationName))
  subdataframe <-data.frame(date=date, urldate = paste(substation$url_all, date ,sep=""))
  # ---------- Xpath ---------- #
  inputxpathName <- c(iterm) # "ex: press"
  xpathrain <- "//table[@id='MyTable']/tbody/tr/td[11]" # Xpath for rain data
  xpathHum <- "//table[@id='MyTable']/tbody/tr/td[6]" # Xpath for RH data
  xpathTtem <- "//table[@id='MyTable']/tbody/tr/td[4]" # Xpath for Temperature data
  xpathPres <- "//table[@id='MyTable']/tbody/tr/td[2]" # Xpath for StnPres data
  XpathName <- c("precipitation", "Relative humidity", "Temperature", "pressure")
  xpathurl <- c(xpathrain, xpathHum, xpathTtem, xpathPres)
  xpathList <- data.frame(XpathName, xpathurl)
  xpathselect_dataframe <- subset(xpathList, xpathList$XpathName == inputxpathName)
  xpathSelect_result <- as.vector(xpathselect_dataframe$xpathurl)
  #----
  hr24 <- data.frame(Hour=1:24)
  for (i in 1:lengthDate){
    urlhtml <- as.vector(subdataframe$urldate[i])# as.vector(date_dataFrame$urldate[1])
    # doc <- read_html(urls)
    datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
    data <- datadoc %>%
      html_nodes(., xpath = xpathSelect_result)%>%
      html_text
    data_renew <- str_trim(sub("<U+00A0>",replacement ="",data)) # Delete something we don't need
    hr24 <-cbind(hr24, data_renew)
  }
  names(hr24)[2:lengthDatep] <- as.vector(as.factor(date))
  hr24_all <- melt(hr24, id=c("Hour") ) # Let them for one column
  names(hr24_all) <- c("hour", "date", "data")
  POStime <- as.POSIXct(paste(hr24_all$date, hr24_all$hour, sep = " "), "%Y-%m-%d %H", tz="GMT")
  resultTable <- data.frame(time=POStime, data= hr24_all$data)
  names(resultTable)[2] <-c(iterm)
  return(resultTable)
}
stationList <- read.csv("data/new_Station_List.csv")
Station_name <- as.list(as.vector(stationList$engName))

# MVdata <- read.csv("data/mvtime.csv")
shinyServer(function(input, output) {
  output$tabletitleoutput1 <- renderText({
    sprintf("%s station.", input$selectStation)
 })
  output$tabletitleoutput2 <- renderText({
    sprintf("%s station, %s", input$selectStation, input$selectitem)
  })
  #ANBU_press <- getDataformCWB("BANQIAO", a, b, "Press")
	output$tabledata <- renderDataTable({
	 dataGetfromCWB_P <- getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "precipitation")
	 dataGetfromCWB_H <- getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "Relative humidity")
	 dataGetfromCWB_T <- getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "Temperature")
	 dataGetfromCWB_Pre <- getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "pressure")
	 dataGetfromCWB <- data.frame(Time = dataGetfromCWB_P$time, Temperature = dataGetfromCWB_T$Temperature, precipitation = dataGetfromCWB_P$precipitation, Relative_humidity = dataGetfromCWB_H[[2]], pressure = dataGetfromCWB_Pre$pressure)
	})
  output$plotlyData <- renderPlotly({
    dataGetfromCWB <- getDataformCWB(input$selectStation, input$dates[1], input$dates[2], input$selectitem)
    dataGetfromCWB[2]
   dataplotly <- plot_ly(
     data = dataGetfromCWB, 
     x = dataGetfromCWB$time, 
     y = as.vector(dataGetfromCWB[[2]]), 
     type = "scatter", 
     mode = "liners+markers"
   )
   dataplotly
  })
  output$downloadData <- downloadHandler(
    filename = 'data.csv',
    content = function(file) {
      write.csv(data.frame(Time = getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "precipitation")[[1]], 
                           Temperature = getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "Temperature")[[2]], 
                           precipitation = getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "precipitation")[[2]], 
                           Relative_humidity = getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "Relative humidity")[[2]], 
                           pressure = getDataformCWB(input$selectStation, input$dates[1], input$dates[2], "pressure")[[2]]), 
                file)
    }
  )
})
