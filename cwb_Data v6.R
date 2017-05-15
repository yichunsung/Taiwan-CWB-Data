# Library Packages
library(magrittr)
library(httr)
library(rvest)
library(stringr)
library(reshape2)
library(knitr)

setwd('c:/Taiwan-CWB-Data')
Sys.setlocale(category = "LC_ALL", locale = "")

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
  
  substation <- data.frame(subset(stationListnew, stationListnew$Name == inputStationName))
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
  
  XpathName <- c("Rain", "Hum", "Tem", "Press")
  
  xpathurl <- c(xpathrain, xpathHum, xpathTtem, xpathPres)
  
  xpathList <- data.frame(XpathName, xpathurl)
  
  xpathselect_dataframe <- subset(xpathList, xpathList$XpathName == inputxpathName)
  
  xpathSelect_result <- as.vector(xpathselect_dataframe$xpathurl)
  
  #-----
  
  
  
  hr24 <- data.frame(Hour=1:24) # set one day time
  
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

getDataformCWB_ENG <- function(station, timerange1, timerange2, iterm){
  
  
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
  
  XpathName <- c("Rain", "Hum", "Tem", "Press")
  
  xpathurl <- c(xpathrain, xpathHum, xpathTtem, xpathPres)
  
  xpathList <- data.frame(XpathName, xpathurl)
  
  xpathselect_dataframe <- subset(xpathList, xpathList$XpathName == inputxpathName)
  
  xpathSelect_result <- as.vector(xpathselect_dataframe$xpathurl)
  
  #-----
  
  
  
  hr24 <- data.frame(Hour=1:24) # set one day time
  
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


StationAllTable <- function(station, StartDate, EndDate){
  station_Press <- getDataformCWB(station, StartDate, EndDate, "Press")
  station_Hum <- getDataformCWB(station, StartDate, EndDate, "Hum")
  station_Tem <- getDataformCWB(station, StartDate, EndDate, "Tem")
  station_Rain <- getDataformCWB(station, StartDate, EndDate, "Rain")
  Starion_All <- data.frame(time=station_Press[[1]], 
                            rf = station_Rain[[2]], 
                            Press = station_Press[[2]], 
                            temperture = station_Tem[[2]],
                            Hum = station_Hum[[2]])
  return(Starion_All)
}

StationAllTable_engName <- function(station, StartDate, EndDate){
  station_Press <- getDataformCWB_ENG(station, StartDate, EndDate, "Press")
  station_Hum <- getDataformCWB_ENG(station, StartDate, EndDate, "Hum")
  station_Tem <- getDataformCWB_ENG(station, StartDate, EndDate, "Tem")
  station_Rain <- getDataformCWB_ENG(station, StartDate, EndDate, "Rain")
  Starion_All <- data.frame(time=station_Press[[1]], 
                            rf = station_Rain[[2]], 
                            Press = station_Press[[2]], 
                            temperture = station_Tem[[2]],
                            Hum = station_Hum[[2]])
  return(Starion_All)
}

Zhudong <- StationAllTable("竹東", "2017-03-19", "2017-05-12")
Hutoupi <- StationAllTable_engName("Hutoupi", "2017-03-19", "2017-05-12")
JS <- StationAllTable("礁溪", "2017-03-19", "2017-05-12")
Beiliao <- StationAllTable("北寮", "2017-03-19", "2017-05-12")
FS <- StationAllTable("鳳山", "2017-03-19", "2017-05-12")
GS <- StationAllTable("金山", "2017-03-19", "2017-05-12")
YMS <- StationAllTable_engName("ZHUZIHU", "2017-03-19", "2017-05-12")



write.csv(Zhudong, "c://Taiwan-CWB-Data/writeCSV/竹東.csv")
write.csv(Hutoupi, "c://Taiwan-CWB-Data/writeCSV/虎頭埤.csv")
write.csv(JS, "c://Taiwan-CWB-Data/writeCSV/礁溪.csv")
write.csv(Beiliao, "c://Taiwan-CWB-Data/writeCSV/北寮.csv")
write.csv(FS, "c://Taiwan-CWB-Data/writeCSV/鳳山.csv")
write.csv(GS, "c://Taiwan-CWB-Data/writeCSV/金山.csv")
write.csv(YMS, "c://Taiwan-CWB-Data/writeCSV/竹子湖.csv")


# test area=========================================================

names(ANBU_press) <- c("hour", "date", "data")

time <- paste(ANBU_press$date, ANBU_press$hour, sep = " ")
POStime <- as.POSIXct(time, "%Y-%m-%d %H", tz="GMT")

resultTable <- data.frame(time=POStime, data= ANBU_press$data)

#===================================================================
