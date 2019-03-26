source('downloadCWBData.R')

library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

cwbList1to200 <- readRDS("cwbList1to200.rds")

date <- Sys.Date()-1

for(i in 1:200){
  cwbList1to200[[i]] <-rbind(cwbList1to200[[i]],
                       StationAllTable_engName(as.vector(stationList$engName[i]), date, date)
  )
  
}

# data save
saveRDS(cwbList1to200, 'cwbList1to200.rds')