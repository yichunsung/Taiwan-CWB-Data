source('downloadCWBData.R')

library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

date <- Sys.Date()-1
# 1~200筆
cwbList1to200 <- list()
for(i in 1:200){
  cwbList1to200[[i]] <- StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  print(paste( i/nrow(stationList)*100, "%", sep = ""))
}
names(cwbList1to200) <- stationList$engName[1:200]

# data save
saveRDS(cwbList1to200, 'cwbList1to200.rds')

