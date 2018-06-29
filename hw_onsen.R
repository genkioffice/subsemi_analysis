library(readxl)
onsendata <- read_excel("onsen.xls")
onsendata <- na.omit(onsendata)
myname <- c("pre","number","sprint","hotel","cap","pop","tax")
