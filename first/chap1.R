# setup
library("xtable") 
library("gdata")
#library() install some libraries 
search()

# return list of used libraries
#library(help="xtable")
# ?plot
# ?function returns description of
x <- 10
rm(x) #delete value
ls() # return character with element of variables 
# you can check data type by mode() 
mode(ls())
# datalibrary(readx1)
library("readx1")
libor <-read_excel("csv")

cvdata = read.csv("cv.csv")
#var returns 分散共分散行列
str(cvdata) #return structure


