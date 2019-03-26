source('downloadCWBData.R')

library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

date <- Sys.Date()-1

# 401~最後

stationList <- stationList[401:nrow(stationList), ]

cwbList401toEnd <- list()
for(i in 1:nrow(stationList)){
  cwbList401toEnd[[i]] <- StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  print(paste( i/nrow(stationList)*100, "%", sep = ""))
  
}
names(cwbList401toEnd) <- stationList$engName[1:nrow(stationList)]

# data save
saveRDS(cwbList401toEnd, 'cwbList401toEnd.rds')