library(readxl)
onsendata <- read_excel("onsen.xls")
onsendata <- na.omit(onsendata)
onsendata <- onsendata[-1,]
myname <- c("pre","number","spring","hotel","cap","pop","tax")
names(onsendata) <- myname
# convert chr datatype to numeric
prefecture <- onsendata$pre
onsendata <- as.data.frame(lapply(onsendata[,c("number","spring","hotel","cap","pop","tax")],as.numeric))
onsendata <- cbind(prefecture,onsendata) # combine dataframe
names(onsendata) <- myname

#plot correlation of dependent variables with explanatory variables
dev.off(dev.list()) #close all graphs
par(mar=c(3,3,3,3)) #modify margins
par(mfrow=c(4,3)) #to display 6(5) graph in the same page
par(mgp=c(0,0,0)) #to modify position of axis label
for (y in c("pop","tax")){
  for( x in names(onsendata)[-1]){
    plot(onsendata[,x] , onsendata[,y], xlab = "", ylab = "", bty="n",xaxt="n",yaxt="n")
    axis(side=1,lwd.ticks = 0.3,tcl=0.3) #lwd.tics sets the thickess of axis whisker
    axis(side=2,lwd.ticks = 0.3,tcl=0.3) #tcl controls the length of whisker
    title(ylab=y,line=0.8,cex.lab=0.9)  #line is the distance btw axis and axis label
    title(xlab=x,line=0.8,cex.lab=0.9) #cex.lab controls font size
  }
}

#multi-linear analysis
result_pop <- lm(pop ~ number + spring + hotel + cap, data=onsendata)
summary(result_pop)
result_tax <- lm(pop ~ number + spring + hotel + cap, data=onsendata)
summary(result_tax)
