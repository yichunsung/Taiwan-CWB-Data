source('downloadCWBData.R')

library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

cwbList201to400 <- readRDS("cwbList201to400.rds")

stationList <- stationList[201:400, ]

date <- Sys.Date()-1

for(i in 1:nrow(stationList)){
  cwbList201to400[[i]] <-rbind(cwbList201to400[[i]],
                       StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  )
  
}

# data save
saveRDS(cwbList201to400, 'cwbList201to400.rds')