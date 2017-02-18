library(magrittr)
library(httr)
library(rvest)
library(stringr)
library(reshape2)
library(knitr)
Sys.setlocale(category = "LC_ALL", locale = "")
source("data/cwb_Data v4.R")
# MVdata <- read.csv("data/mvtime.csv")

shinyServer(function(input, output) {
	output$dateoutput <- renderText({
		sprintf("this %s to %s", input$dates[1], input$dates[2])
		})
 # output$MVdatatable <- renderDataTable(MVdata)
  output$raindata <- renderDataTable(C0D560_Rain_for_day_hr24_all)
 # output$humdata <- renderDataTable(C0D560_HUM_for_day_hr24_all)
  # output$temdata <- renderDataTable(C0D560_tem_for_day_hr24_all)
  # output$pressdata <- renderDataTable(C0D560_press_for_day_hr24_all)
  output$downloadData <- downloadHandler(
    filename = 'data.csv',
    content = function(file) {
      write.csv(C0D560_Rain_for_day_hr24_all, file)
    }
  )
})
