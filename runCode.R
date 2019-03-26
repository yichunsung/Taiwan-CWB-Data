source('downloadCWBData.R')

library(data.table)
library(readxl)



stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")


for(i in 1:200){
  svePath <- paste("writeData/", as.vector(stationList$engName[i]), ".csv",  sep = "")
  download_cwb_data_eng(as.vector(stationList$engName[i]), "2019-01-31", "2019-01-31", svePath)
  
}

for(i in 201:400){
  svePath <- paste("writeData/", as.vector(stationList$engName[i]), ".csv",  sep = "")
  download_cwb_data_eng(as.vector(stationList$engName[i]), "2019-01-31", "2019-01-31", svePath)
  
}

for(i in 401:nrow(stationList)){
  svePath <- paste("writeData/", as.vector(stationList$engName[i]), ".csv",  sep = "")
  download_cwb_data_eng(as.vector(stationList$engName[i]), "2019-01-31", "2019-01-31", svePath)
  
}


svePath <- paste("writeData/", 'Jinsha', ".csv",  sep = "")
download_cwb_data_eng("Jinsha", "2019-01-31", "2019-01-31", svePath)
