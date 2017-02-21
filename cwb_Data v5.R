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


  # ---------- 輸入目標測站 ---------- #
  # Load Station List

  stationList <- read.csv("data/StationList.csv")

  inputStationName <- c(station) # "鞍部"


  # ---------- 輸入日期範圍 ---------- #

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

  substation <- data.frame(subset(stationListnew, stationListnew$stationname == inputStationName))
  subdataframe <-data.frame(date=date, urldate = paste(substation$url_all, date ,sep=""))

  # ---------- Xpath ---------- #
  inputxpathName <- c(iterm) # "氣壓"

  # 雨量
  xpathrain <- "//table[@id='MyTable']/tbody/tr/td[11]" # Xpath for rain data

  # 濕度
  xpathHum <- "//table[@id='MyTable']/tbody/tr/td[6]" # Xpath for RH data

  # 氣溫
  xpathTtem <- "//table[@id='MyTable']/tbody/tr/td[4]" # Xpath for Temperature data

  # 氣壓
  xpathPres <- "//table[@id='MyTable']/tbody/tr/td[2]" # Xpath for StnPres data

  XpathName <- c("雨量", "濕度", "氣溫", "氣壓")

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
    data_renew <- str_trim(sub("<U+00A0>",replacement ="",data)) # 去掉怪東西
    hr24 <-cbind(hr24, data_renew)

  }
  names(hr24)[2:lengthDatep] <- as.vector(as.factor(date))
  hr24_all <- melt(hr24, id=c("Hour") ) # 把他們排成一排

  return(hr24_all)
}


liststation <- c("竹東")
datesss <- c('2017-01-18')
ANBU_press <- getDataformCWB(liststation, "2017-02-01", "2017-02-01", "氣壓")
