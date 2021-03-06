# Library Packages
library(magrittr)
library(httr)
library(rvest)
library(stringr)
setwd('c:/Taiwan-CWB-Data')
Sys.setlocale(category = "LC_ALL", locale = "")


# ----------輸入日期範圍---------- #

fromdate <- as.Date("2016-10-01")
todate <- as.Date("2017-01-16")
date <- seq.Date(fromdate, todate, "day")


# ----------三大測站的URL輸入---------- #

# 竹東 編號: C0D560
C0D560_url <- "http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station=C0D560&stname=%25E7%25AB%25B9%25E6%259D%25B1&datepicker="
C0D560_date_dataFrame <- data.frame(date=date, urldate = paste(C0D560_url, date ,sep=""))

# 虎頭埤 編號：C0O970
C0O970_url <- "http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station=C0O970&stname=%25E8%2599%258E%25E9%25A0%25AD%25E5%259F%25A4&datepicker="
C0O970_date_dataFrame <- data.frame(date=date, urldate = paste(C0O970_url, date ,sep=""))

# 礁溪 編號：C0U600
C0U600_url <- "http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station=C0U600&stname=%25E7%25A4%2581%25E6%25BA%25AA&datepicker="
C0U600_date_dataFrame <- data.frame(date=date, urldate = paste(C0U600_url, date ,sep=""))


# ----------輸入Xpath----------

# 雨量
  xpathrain <- "//table[@id='MyTable']/tbody/tr/td[11]" # Xpath for rain data

# 濕度
  xpathHum <- "//table[@id='MyTable']/tbody/tr/td[6]" # Xpath for RH data

# 氣溫
  xpathTtem <- "//table[@id='MyTable']/tbody/tr/td[4]" # Xpath for Temperature data

# 氣壓
  xpathPres <- "//table[@id='MyTable']/tbody/tr/td[2]" # Xpath for StnPres data


# rain_day <-data.frame(date=date)

# ======竹東
# 1 雨量
C0D560_Rain_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0D560_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathrain)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data)) # 去掉怪東西
  C0D560_Rain_for_day_hr24 <-cbind(C0D560_Rain_for_day_hr24, data_renew)

}
names(C0D560_Rain_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0D560_Rain_for_day_hr24_all <- melt(C0D560_Rain_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0D560_Rain_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_rain_data_20161001to20170116.csv")


# 2 濕度

C0D560_HUM_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0D560_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathHum)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data)) # 去掉怪東西
  C0D560_HUM_for_day_hr24 <-cbind(C0D560_HUM_for_day_hr24, data_renew)

}
names(C0D560_HUM_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0D560_HUM_for_day_hr24_all <- melt(C0D560_HUM_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0D560_HUM_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_hum_data_20161001to20170116.csv")

# 3 氣溫

C0D560_tem_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0D560_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathTtem)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data))# 去掉怪東西
  C0D560_tem_for_day_hr24 <-cbind(C0D560_tem_for_day_hr24, data_renew)

}
names(C0D560_tem_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0D560_tem_for_day_hr24_all <- melt(C0D560_tem_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0D560_tem_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_tem_data_20161001to20170116.csv")

# 4 氣壓

C0D560_press_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0D560_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathPres)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data))# 去掉怪東西
  C0D560_press_for_day_hr24 <-cbind(C0D560_press_for_day_hr24, data_renew)

}
names(C0D560_press_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0D560_press_for_day_hr24_all <- melt(C0D560_press_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0D560_press_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_竹東_press_data_20161001to20170116.csv")


# ======虎頭埤
# 1 雨量
C0O970_Rain_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0O970_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathrain)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data)) # 去掉怪東西
  C0O970_Rain_for_day_hr24 <-cbind(C0O970_Rain_for_day_hr24, data_renew)

}
names(C0O970_Rain_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0O970_Rain_for_day_hr24_all <- melt(C0O970_Rain_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0O970_Rain_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_虎頭埤_rain_data_20161001to20170116.csv")


# 2 濕度

C0O970_HUM_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0O970_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathHum)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data)) # 去掉怪東西
  C0O970_HUM_for_day_hr24 <-cbind(C0O970_HUM_for_day_hr24, data_renew)

}
names(C0O970_HUM_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0O970_HUM_for_day_hr24_all <- melt(C0O970_HUM_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0O970_HUM_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_虎頭埤_hum_data_20161001to20170116.csv")

# 3 氣溫

C0O970_tem_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0O970_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathTtem)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data))# 去掉怪東西
  C0O970_tem_for_day_hr24 <-cbind(C0O970_tem_for_day_hr24, data_renew)

}
names(C0O970_tem_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0O970_tem_for_day_hr24_all <- melt(C0O970_tem_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0O970_tem_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_虎頭埤_tem_data_20161001to20170116.csv")

# 4 氣壓

C0O970_press_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0O970_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathPres)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data))# 去掉怪東西
  C0O970_press_for_day_hr24 <-cbind(C0O970_press_for_day_hr24, data_renew)

}
names(C0O970_press_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0O970_press_for_day_hr24_all <- melt(C0O970_press_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0O970_press_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_虎頭埤_press_data_20161001to20170116.csv")


# ======礁溪
# 1 雨量
C0U600_Rain_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0U600_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathrain)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data)) # 去掉怪東西
  C0U600_Rain_for_day_hr24 <-cbind(C0U600_Rain_for_day_hr24, data_renew)

}
names(C0U600_Rain_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0U600_Rain_for_day_hr24_all <- melt(C0U600_Rain_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0U600_Rain_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_礁溪_rain_data_20161001to20170116.csv")


# 2 濕度

C0U600_HUM_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0U600_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathHum)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data)) # 去掉怪東西
  C0U600_HUM_for_day_hr24 <-cbind(C0U600_HUM_for_day_hr24, data_renew)

}
names(C0U600_HUM_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0U600_HUM_for_day_hr24_all <- melt(C0U600_HUM_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0U600_HUM_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_礁溪_hum_data_20161001to20170116.csv")

# 3 氣溫

C0U600_tem_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0U600_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathTtem)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data))# 去掉怪東西
  C0U600_tem_for_day_hr24 <-cbind(C0U600_tem_for_day_hr24, data_renew)

}
names(C0U600_tem_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0U600_tem_for_day_hr24_all <- melt(C0U600_tem_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0U600_tem_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_礁溪_tem_data_20161001to20170116.csv")

# 4 氣壓

C0U600_press_for_day_hr24 <- data.frame(Hour=1:24)

for (i in 1:108){
  urlhtml <- as.vector(C0U600_date_dataFrame$urldate[i])# as.vector(date_dataFrame$urldate[1])
  # doc <- read_html(urls)
  datadoc <-read_html(urlhtml)# read_html(as.vector(date_dataFrame$urldate[1]))
  data <- datadoc %>%
    html_nodes(., xpath = xpathPres)%>%
    html_text
  data_renew <- str_trim(sub("<U+00A0>",replacement="",data))# 去掉怪東西
  C0U600_press_for_day_hr24 <-cbind(C0U600_press_for_day_hr24, data_renew)

}
names(C0U600_press_for_day_hr24)[2:109] <- as.vector(as.factor(date))
C0U600_press_for_day_hr24_all <- melt(C0U600_press_for_day_hr24, id=c("Hour") ) # 把他們排成一排

write.csv(C0U600_press_for_day_hr24_all, file="c://Taiwan-CWB-Data/writeCSV/C0D560_礁溪_press_data_20161001to20170116.csv")



# rain <- doc %>%
#  html_nodes(., xpath = xpathrain)%>%
#  html_text
