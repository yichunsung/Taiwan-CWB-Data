# Taiwan-CWB-Data
Taiwan Central Weather Bureau Data

* Web system Demo  Beta v1:
https://yichunsung.shinyapps.io/TaiwanCWB/

# 使用方式

clone我的Repository到本機端並進入

打開終端機進入Repository路徑之下，進入R環境或R console，輸入`source("downloadCWBData.R")`使用`download_cwb_data()`函數。

`download_cwb_data("測站名字", "起始日期", "結束日期", "存檔路徑")`

範例：
```{r}
source("downloadCWBData.R")
download_cwb_data("竹東", "2017-01-01", "2017-02-01", "~/Documents/zd.csv") # 記得一定要把副檔名.csv寫清楚

```

## 資料來源

所有資料來源都是台灣中央氣象局資料

* 台灣中央氣象局網站：
http://www.cwb.gov.tw/eng/index.htm
* 中央氣象局資料查詢系統：
http://e-service.cwb.gov.tw/HistoryDataQuery/index.jsp

# 更新日誌

## 2018-01-31

### 修正氣象局資料遺失時的錯誤

## 2017-02-28

### 修正R檔案第五版，Web介面Beta第一版釋出

## 2017-02-20

### 修正R檔案第四版，修正web介面日期選單

## 2017-02-19

### 新增第三版

微幅修正，並且加入web介面供使用者使用

## 2017-01-20

### 新增第二版

修正成適合連續作圖的資料形式

## 2017-01-17

### 新增第一版資料

加入 竹南、虎頭埤、礁溪測站 