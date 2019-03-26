source('downloadCWBData.R')

library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

date <- Sys.Date()-1

# 201~400筆
stationList <- stationList[201:400, ]

cwbList201to400 <- list()
for(i in 1:nrow(stationList)){
  cwbList201to400[[i]] <- StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  print(paste( i/nrow(stationList)*100, "%", sep = ""))
}
names(cwbList201to400) <- stationList$engName[1:nrow(stationList)]

# data save
saveRDS(cwbList201to400, 'cwbList201to400.rds')