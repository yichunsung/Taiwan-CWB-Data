source('downloadCWBData.R')

library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

cwbList401toEnd <- readRDS("cwbList401toEnd.rds")

stationList <- stationList[401:nrow(stationList), ]

date <- Sys.Date()-1

for(i in 1:nrow(stationList)){
  cwbList201to400[[i]] <-rbind(cwbList401toEnd[[i]],
                               StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  )
  
}

# data save
saveRDS(cwbList401toEnd, 'cwbList401toEnd.rds')