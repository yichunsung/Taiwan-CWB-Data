# 0. Train data 
# data munging

Tai_train_data <- read.csv("c://comp/dsp_Typhoon_Taipower/data/train.csv")
# 城市村里黏在一起
Tai_train_data <- paste(Tai_train_data$CityName, Tai_train_data$TownName, Tai_train_data$VilName, sep = "") %>% 
  cbind(Tai_train_data, .)
names(Tai_train_data)[13] <- "area"


# 1. Typhoon list from CWB database
# source : http://rdc28.cwb.gov.tw/TDB/ntdb/pageControl/typhoon
# data munging
library(dplyr)
library(magrittr)

typ_cwb_int <- read.csv("c://comp/dsp_Typhoon_Taipower/data/int_cwb_database.csv")
names(typ_cwb_int) <- c("year", # 年份
                        "id", # 編號
                        "c_name", # 中文名稱
                        "name", # English name
                        "life_period", # 生命週期
                        "center_lowest_pa", # 中心最低氣壓
                        "center_stronger_wind", # 中心最大風速
                        "strom_7_R", # 最大7級暴風半徑 
                        "strom_10_R", # 最大10級暴風半徑 
                        "warming_times" # 警報次數
                        )
typ_cwb_int <- subset(typ_cwb_int, typ_cwb_int$life_period != "---")
# Selecting odd row for Typhoon starting time
start_time <-  typ_cwb_int$life_period[seq(1,nrow(typ_cwb_int), 2)] %>% 
  as.character() %>% as.POSIXct(., "%Y/%m/%d %H:%M", tz = "GMT")
# Selecting odd row for Typhoon ending time
end_time <- typ_cwb_int$life_period[seq(from = 2, to= nrow(typ_cwb_int), 2)] %>% 
  as.character() %>% as.POSIXct(., "%Y/%m/%d %H:%M", tz = "GMT")
# Selecting odd row to build a new data frame
typ_cwb_new <- typ_cwb_int[seq(1,nrow(typ_cwb_int), 2),] %>%
  cbind(., start_time, end_time)
# Calculating Typhoon life period
typ_cwb_new$life_period <- (as.Date(typ_cwb_new$end_time) - as.Date(typ_cwb_new$start_time))%>% 
  as.numeric() 
# Converting "---" to ZERO
typ_cwb_new$strom_7_R <- sub("---", replacement =0, typ_cwb_new$strom_7_R) %>% as.numeric()
typ_cwb_new$strom_10_R <- sub("---", replacement =0, typ_cwb_new$strom_10_R) %>% as.numeric()
typ_cwb_new$warming_times <- sub("---", replacement =0, typ_cwb_new$warming_times) %>% as.numeric()
# Rewriting a new csv file
# write.csv(typ_cwb_new, "c://comp/dsp_Typhoon_Taipower/data/new_cwb_database.csv")

tyList <- merge(event_single, typ_cwb_new, by.x="name", by.y="name", all.x=TRUE)
# 2. Typhoon pathways database
# source : http://www.data.jma.go.jp/fcd/yoho/typhoon/route_map
# data munging

# data of Typhoon pathways 
typhoon_path_2014 <- read.csv("c://comp/dsp_Typhoon_Taipower/data/jp_typhoon_table2014.csv")
typhoon_path_2015 <- read.csv("c://comp/dsp_Typhoon_Taipower/data/jp_typhoon_table2015.csv")
typhoon_path_2016 <- read.csv("c://comp/dsp_Typhoon_Taipower/data/jp_typhoon_table2016.csv")
# data of events
events <- read.csv("c://comp/dsp_Typhoon_Taipower/data/events_imfor.csv")
# 去掉雙颱事件
event_single <- events[-8,]
names(event_single)[3] <- "name"
inera <- inner_join(event_single, typhoon_path_2014, by = "name")


# 3.村里戶數
# source : https://data.gov.tw/dataset/32973
# data munging

account_number_2016 <- read.csv("c://comp/dsp_Typhoon_Taipower/data/2016_account_number.csv",header = TRUE)
account_number_2016 <- account_number_2016[-1,1:7]
account_number_2016 <- paste(account_number_2016$site_id, account_number_2016$village, sep = "") %>% 
  cbind(account_number_2016, .)
names(account_number_2016)[8] <- "area"

account_number_2016$area <- sub("臺", "台", account_number_2016$area)
account_number_2016$area <- sub(" ", "", account_number_2016$area)
Tai_train_data$area <- sub("臺", "台", Tai_train_data$area)
combineDF <- merge(Tai_train_data, account_number_2016, by.x="area", by.y="area", all.x=TRUE)

FWTY <- as.numeric(as.vector(combineDF$Fung.wong))/as.numeric(as.vector(combineDF$household_no)) 
combineDF <- cbind(combineDF, FWTY)
combineDF_FWTY<- subset(combineDF, combineDF$FWTY!=0)

SOUDELOR_percent<-as.numeric(as.vector(combineDF$Soudelor))/as.numeric(as.vector(combineDF$household_no)) 
combineDF <- cbind(combineDF, SOUDELOR_percent)
Dujuan_percent<-as.numeric(as.vector(combineDF$Dujuan))/as.numeric(as.vector(combineDF$household_no)) 
combineDF <- cbind(combineDF, Dujuan_percent)
