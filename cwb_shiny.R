setwd("C:/Taiwan-CWB-Data")
dir.create("TaiwanCWB")
dir.create("TaiwanCWB/data")
file.create("TaiwanCWB/ui.R")
file.create("TaiwanCWB/server.R")

runApp("TaiwanCWB")
