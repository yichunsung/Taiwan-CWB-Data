# Taiwan-CWB-Data
Taiwan Central Weather Bureau Data

* Web system Demo  Beta v1:
https://yichunsung.shinyapps.io/TaiwanCWB/

# 使用方式

* 用git 儲存我的repository

Windows使用者請先安裝git，詳細可參閱 ·[30 天精通 Git 版本控管](https://github.com/yichunsung/Learn-Git-in-30-days/blob/master/zh-tw/README.md)，[第 02 天：在 Windows 平台必裝的三套 Git 工具](https://github.com/yichunsung/Learn-Git-in-30-days/blob/master/zh-tw/02.md)。

Git for Windows: http://gitforwindows.org

OSX應該已有內建，沒有的一樣去載。安裝完成後請開啟終端機或是git bush。

1. 移動到你想要儲存這個repository的路徑底下。

Windows:
```{git}
cd c://
```
OSX:
```{git}
cd ~/Documents
```

2. clone我的repository
```{git}
git clone "https://github.com/yichunsung/Taiwan-CWB-Data"
```
這樣就成功將repository複製到本機端了！

* 不想用git就請直接利用Github頁面上的下載功能

右上角有個綠色的`Clone or download`，請下載後放置。

---
* 使用終端機執行

1. 打開終端機進入Repository路徑之下執行R
```{cmd}
$ cd your repository path
$ R
```

2. 輸入`source("downloadCWBData.R")`使用`download_cwb_data()`函數。

`download_cwb_data("測站名字", "起始日期", "結束日期", "存檔路徑")`

範例：
```{r}
source("downloadCWBData.R")
download_cwb_data("竹東", "2017-01-01", "2017-02-01", "~/Documents/zd.csv") # 記得一定要把副檔名.csv寫清楚

```
* 使用R或Rstudio執行

打開R或Rstudio

第一步請找到downloadCWBData.R這支程式接著呼叫這支程式然後使用，語法如下：
```{r}
setwd("你存這個repository的路徑/")
source("downloadCWBData.R")
download_cwb_data("竹東", "2017-01-01", "2017-02-01", "~/Documents/zd.csv") # 記得一定要把副檔名.csv寫清楚

```
* 再看不懂或是有問題的話....

可以利用github上的issues回報問題給我或者聯絡我。
---

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