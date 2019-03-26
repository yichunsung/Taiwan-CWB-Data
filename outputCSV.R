stationList <- read_xlsx("data/new_Station_List.xlsx", sheet = "new_Station_List")

#### 1~200
# read data
cwbList1to200 <- readRDS("cwbList1to200.rds")

stationList1To200 <- stationList[1:200, ]

for(i in 1:nrow(stationList1To200)){
  svePath <- paste("writeData/", as.vector(stationList1To200$Name[i]), ".csv",  sep = "")
  write.csv(cwbList1to200[[i]], svePath)
}


#### 201~400
# read data
cwbList201to400 <- readRDS("cwbList201to400.rds")

stationList201To400 <- stationList[201:400, ]

for(i in 1:nrow(stationList201To400)){
  svePath <- paste("writeData/", as.vector(stationList201To400$Name[i]), ".csv",  sep = "")
  write.csv(cwbList201to400[[i]], svePath)
}

#### 401~End
# read data
cwbList401toEnd <- readRDS("cwbList401toEnd.rds")

stationList401ToEnd <- stationList[401:nrow(stationList), ]

for(i in 1:nrow(stationList401ToEnd)){
  svePath <- paste("writeData/", as.vector(stationList401ToEnd$Name[i]), ".csv",  sep = "")
  write.csv(cwbList401toEnd[[i]], svePath)
}

