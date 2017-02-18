library(magrittr)
library(httr)
library(rvest)
library(stringr)
library(reshape2)
library(knitr)
Sys.setlocale(category = "LC_ALL", locale = "")
source("data/cwb_Data v4.R")
# MVdata <- read.csv("data/mvtime.csv")


shinyUI(fluidPage(
	titlePanel("CWB data"),




      	sidebarLayout(
      		sidebarPanel(
      			dateRangeInput("dates", label = h3("Date range")),
      			downloadButton('downloadData', 'Download')

      		),

      		mainPanel(
      			textOutput("dateoutput"),

      		  tabsetPanel(
      		    tabPanel('竹東雨量', dataTableOutput("raindata"))


      		  )
      		)
        )


))
