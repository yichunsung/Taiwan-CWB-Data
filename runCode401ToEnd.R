source('downloadCWBData.R')

library(data.table)
library(readxl)

stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

date <- Sys.Date()-2

for(i in 401:nrow(stationList)){
  svePath <- paste("writeData/", date, "-", as.vector(stationList$engName[i]), ".csv",  sep = "")
  download_cwb_data_eng(as.vector(stationList$engName[i]), date, date, svePath)
  
}
