#==============
# CWB pic downloader

yesterday <- Sys.Date()-1

download_str <- paste(substr(yesterday, 7, 7), substr(yesterday, 9, 10), sep = "")

pic_date <- c(download_str)
url_pic <-paste("http://www.cwb.gov.tw/V7/observe/rainfall/Data/hk", pic_date, "000.jpg", sep = "")
destfile_pic <- paste("c://Taiwan-CWB-Data/writeCSV/pic/", yesterday, ".jpg", sep = "")
for(i in 1:length(pic_date)){
  download.file(url_pic[i], destfile_pic[i], mode="wb")
}
