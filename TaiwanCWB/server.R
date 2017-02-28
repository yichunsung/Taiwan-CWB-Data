library(magrittr)
library(httr)
library(rvest)
library(stringr)
library(reshape2)
library(knitr)
Sys.setlocale(category = "LC_ALL", locale = "cht")
getDataformCWB <- function(station, timerange1, timerange2, iterm){
  
  
  # ---------- input Targat Station ---------- #
  # Load Station List
  
  stationList <- read.csv("data/new_Station_List.csv")
  
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
  
  # Rain
  xpathrain <- "//table[@id='MyTable']/tbody/tr/td[11]" # Xpath for rain data
  
  # Hum
  xpathHum <- "//table[@id='MyTable']/tbody/tr/td[6]" # Xpath for RH data
  
  # Tem
  xpathTtem <- "//table[@id='MyTable']/tbody/tr/td[4]" # Xpath for Temperature data
  
  # Press
  xpathPres <- "//table[@id='MyTable']/tbody/tr/td[2]" # Xpath for StnPres data
  
  XpathName <- c("precipitation", "RH", "Temperature", "pressure")
  
  xpathurl <- c(xpathrain, xpathHum, xpathTtem, xpathPres)
  
  xpathList <- data.frame(XpathName, xpathurl)
  
  xpathselect_dataframe <- subset(xpathList, xpathList$XpathName == inputxpathName)
  
  xpathSelect_result <- as.vector(xpathselect_dataframe$xpathurl)
  
  #-----
  
  
  
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
  
  return(hr24_all)
}


stationList <- read.csv("data/new_Station_List.csv")
Station_name <- as.list(as.vector(stationList$engName))


# MVdata <- read.csv("data/mvtime.csv")

shinyServer(function(input, output) {

  output$dateoutput <- renderText({
    sprintf("測站%s, 項目%s", input$selectStation, input$selectitem)
 })

  #ANBU_press <- getDataformCWB("BANQIAO", a, b, "Press")
	output$tabledata <- renderDataTable(

	   getDataformCWB(input$selectStation, input$dates[1], input$dates[2], input$selectitem))
 # output$MVdatatable <- renderDataTable(MVdata)
  # output$raindata <- renderDataTable(C0D560_Rain_for_day_hr24_all)
 # output$humdata <- renderDataTable(C0D560_HUM_for_day_hr24_all)
  # output$temdata <- renderDataTable(C0D560_tem_for_day_hr24_all)
  # output$pressdata <- renderDataTable(C0D560_press_for_day_hr24_all)
  output$downloadData <- downloadHandler(
    filename = 'data.csv',
    content = function(file) {
      write.csv(getDataformCWB(input$selectStation, input$dates[1], input$dates[2], input$selectitem), file)
    }
  )
})
