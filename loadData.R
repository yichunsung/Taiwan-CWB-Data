library(RJSONIO)
library(RCurl)
library(jsonlite)

# grab the data
Station_data <- fromJSON("data/st.json")

# Then covert from JSON into a list in R
# grab List object title for Station ID
Station_data_dataframe <- as.data.frame(Station_data)
stid <- names(Station_data_dataframe)

#消除奇怪的符號
stid <- sub("X",replacement ="", stid)

# grab data from list to as.vector
# "板橋" <- Station_data[[1]][1]
# "淡水" <- Station_data[[2]][1]
# "鞍部"<- Station_data[[3]][1]

chineseNameSelectList <-c()
EngNameSelectList <-c()
AreaSelectList <-c()
for (i in 1:537){
  chineseNameSelect <- Station_data[[i]][1]
  chineseNameSelectList<-c(chineseNameSelectList, chineseNameSelect)
  EngNameSelect <- Station_data[[i]][2]
  EngNameSelectList<-c(EngNameSelectList, EngNameSelect)
  AreaSelect <- Station_data[[i]][3]
  AreaSelectList<-c(AreaSelectList, AreaSelect)
}

# 會有一些奇怪的空白在字之後，把他去掉
chineseNameSelectList <- sub("            ", replacement = "", chineseNameSelectList)
AreaSelectList <- sub("    ", replacement = "", AreaSelectList)

# fit in data.frame
New_Station_List <- data.frame(id=stid, Name=chineseNameSelectList, engName=EngNameSelectList, Area=AreaSelectList) 

# output Data for csv file
write.csv(New_Station_List, "Station_List.csv")

