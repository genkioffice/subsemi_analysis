#set path(path have been already set)
print(getwd())

#set libraries
print(search())
library(gdata) #to read xls data
library(treemap) #to use treemap plot... you may have to install ggplot2 & treemap and some related libraries

#load data
population = read.xls("2015_population.xls")
#delete useless columns
population = population[c("X.5","X.6","X.7")] #dataframe of 3 factors
c_name = c("state","city","population") #to set columns name
names(population) <- c_name
print(names(population))

#modify population column
population <- population[11:length(population[[2]]),] #delete useless values
population$population = sapply(gsub(',','',population$population),function(x) x[1]) # to eliminate comma on population column
population$population = as.numeric(population$population)#to change character d-type into numeric d-type

#make treemap
states = population$state #to reshape population dataframe
population_without_allState <- subset(population, !(city %in% states)) # delete rows where state and city have a same name
treemap(population_without_allState,
        index=c("state","city"),vSize = "population", title = "Distribution of the population in Japan",type = "index",fontsize.labels = c(12,8),
        fontcolor.labels = c("white","orange"),fontface.labels = c(2,1),bg.labels =c("transparent"),align.labels = list(c("center","center"),c("right","bottom")),
        overlap.labels = 0.5,inflate.labels = F, fontfamily.title ="HiraKakuPro-W3", fontfamily.labels = "HiraKakuPro-W3",
        fontfamily.legend = "HiraKakuPro-W3" )

