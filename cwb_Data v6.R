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


liststation <- c("Zhudong")
Zhudong_Press <- getDataformCWB("Zhudong", "2017-03-14", "2017-03-19", "Press")
Zhudong_Hum <- getDataformCWB("Zhudong", "2017-03-14", "2017-03-19", "Hum")
Zhudong_Tem <- getDataformCWB("Zhudong", "2017-03-14", "2017-03-19", "Tem")
Zhudong_Rain <- getDataformCWB("Zhudong", "2017-03-14", "2017-03-19", "Rain")

Hutoupi_Press <- getDataformCWB("Hutoupi", "2017-03-14", "2017-03-19", "Press")
Hutoupi_Hum <- getDataformCWB("Hutoupi", "2017-03-14", "2017-03-19", "Hum")
Hutoupi_Tem <- getDataformCWB("Hutoupi", "2017-03-14", "2017-03-19", "Tem")
Hutoupi_Rain <- getDataformCWB("Hutoupi", "2017-03-14", "2017-03-19", "Rain")

Chiaoshi_Press <- getDataformCWB("Chiaoshi", "2017-03-14", "2017-03-19", "Press")
Chiaoshi_Hum <- getDataformCWB("Chiaoshi", "2017-03-14", "2017-03-19", "Hum")
Chiaoshi_Tem <- getDataformCWB("Chiaoshi", "2017-03-14", "2017-03-19", "Tem")
Chiaoshi_Rain <- getDataformCWB("Chiaoshi", "2017-03-14", "2017-03-19", "Rain")

Beiliao_Press <- getDataformCWB("Beiliao", "2017-03-20", "2017-03-21", "Press")
Beiliao_Hum <- getDataformCWB("Beiliao", "2017-03-20", "2017-03-21", "Hum")
Beiliao_Tem <- getDataformCWB("Beiliao", "2017-03-20", "2017-03-21", "Tem")
Beiliao_Rain <- getDataformCWB("Beiliao", "2017-03-20", "2017-03-21", "Rain")

write.csv(Zhudong_Press, "c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_Zhudong_Press.csv")
write.csv(Zhudong_Hum, "c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_Zhudong_Hum.csv")
write.csv(Zhudong_Tem, "c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_Zhudong_Tem.csv")
write.csv(Zhudong_Rain, "c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_Zhudong_Rain.csv")

write.csv(Hutoupi_Press, "c://Taiwan-CWB-Data/writeCSV/Hutoupi_Press.csv")
write.csv(Hutoupi_Hum, "c://Taiwan-CWB-Data/writeCSV/Hutoupi_Hum.csv")
write.csv(Hutoupi_Tem, "c://Taiwan-CWB-Data/writeCSV/Hutoupi_Tem.csv")
write.csv(Hutoupi_Rain, "c://Taiwan-CWB-Data/writeCSV/Hutoupi_Rain.csv")

write.csv(Beiliao_Press, "c://Taiwan-CWB-Data/writeCSV/Beiliao_Press.csv")
write.csv(Beiliao_Hum, "c://Taiwan-CWB-Data/writeCSV/Beiliao_Hum.csv")
write.csv(Beiliao_Tem, "c://Taiwan-CWB-Data/writeCSV/Beiliao_Tem.csv")
write.csv(Beiliao_Rain, "c://Taiwan-CWB-Data/writeCSV/Beiliao_Rain.csv")

write.csv(Chiaoshi_Press, "c://Taiwan-CWB-Data/writeCSV/Chiaoshi_Press.csv")
write.csv(Chiaoshi_Hum, "c://Taiwan-CWB-Data/writeCSV/Chiaoshi_Hum.csv")
write.csv(Chiaoshi_Tem, "c://Taiwan-CWB-Data/writeCSV/Chiaoshi_Tem.csv")
write.csv(Chiaoshi_Rain, "c://Taiwan-CWB-Data/writeCSV/Chiaoshi_Rain.csv")

# test area=========================================================

names(ANBU_press) <- c("hour", "date", "data")

time <- paste(ANBU_press$date, ANBU_press$hour, sep = " ")
POStime <- as.POSIXct(time, "%Y-%m-%d %H", tz="GMT")

resultTable <- data.frame(time=POStime, data= ANBU_press$data)

#===================================================================
