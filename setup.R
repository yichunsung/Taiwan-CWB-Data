source('downloadCWBData.R')


library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

date <- Sys.Date()-1
# 1~200筆
cwbList1to200 <- list()
for(i in 1:200){
  cwbList1to200[[i]] <- StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  
}
names(cwbList1to200) <- stationList$engName[1:200]

# 201~400筆
cwbList201to400 <- list()
for(i in 201:400){
  cwbList201to400[[201]] <- StationAllTable_engName(as.vector(stationList$engName[201]), date, date)
  
}
names(cwbList201to400) <- stationList$engName[201:400]

# 401~最後
cwbList401toEnd <- list()
for(i in 401:nrow(stationList)){
  cwbList401toEnd[[i]] <- StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  
}
names(cwbList401toEnd) <- stationList$engName[401:nrow(stationList)]