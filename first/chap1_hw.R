#notice: you may have to install ggplot2 & treemap and some related libraries by yourself
#set path(path have been already set)
print(getwd())

#set libraries
print(search())
library(gdata) #to read xls data
library(treemap) #to use treemap plot
library(dplyr) #to use great data modify function, like group_by

#load data
population <- read.xls("2015_population.xls")
#delete useless columns
population <- population[c("X.5","X.6","X.7","X.10")] #dataframe of 3 factors
c_name <- c("state","city","population","trend") #to set columns name
names(population) <- c_name
print(names(population))

#modify population column
population <- population[11:length(population[[2]]),] #delete useless values
population$population <- sapply(gsub(',','',population$population),function(x) x[1]) # to eliminate comma on population column
population$population <- as.numeric(population$population)#to change character d-type into numeric d-type

#modify trend column
population$trend <- sapply(gsub(',','',population$trend),function(x) x[1])
population$trend <- as.numeric(population$trend)

#make treemap
states <- population$state #to reshape population dataframe
population_without_allState <- subset(population, !(city %in% states)) # delete rows where state and city have a same name
rainbow_color <- rainbow(47,s=0.4) #set colors
treemap(population_without_allState,
        index=c("state","city"),vSize = "population", title = "Distribution of the population in Japan",type = "index",fontsize.labels = c(12,8),
        fontcolor.labels = c("white","orange"),fontface.labels = c(2,1),bg.labels =c("transparent"),align.labels = list(c("center","center"),c("right","bottom")),
        overlap.labels = 0.5,inflate.labels = F, fontfamily.title ="HiraKakuPro-W3", fontfamily.labels = "HiraKakuPro-W3",
        fontfamily.legend = "HiraKakuPro-W3",palette = rainbow_color, border.lwds=c(1,1))

#create function to compute variance
variance <- function(x) var(x) * (length(x)-1)/length(x)

#statistical features in whole Japan
city_mean <- mean(population_without_allState$population)
city_var <- variance(population_without_allState$population)
city_std <- sqrt(city_var)

tmp <- sprintf("Mean of the population per city: %f \nVariance of the population per city: %f\nStd of the population per city: %f",city_mean,city_var,city_std
        )
cat(tmp)

#collect statistical features
group_by_state <- group_by(population_without_allState,state)
means_per_state <- summarise(group_by_state, mean(population)) 
variance_per_state <- summarise(group_by_state,variance(population))
stds_per_state <- summarise(group_by_state,sqrt(variance(population)))
representative_values <- merge(means_per_state,variance_per_state,by = "state") 
representative_values <- merge(representative_values,stds_per_state,by="state")
names(representative_values) <- c('state','mean', 'variance','std')
print(representative_values)

# create function to compute geometric mean
geo_mean <- function(x) max(cumprod(x))^(1/length(x))
geo_var <- function(x) (length(x)-1)/length(x) * (sum((x - geo_mean(x))^2))

#dig into trend column
#whole trend
scalled_trend <- (population_without_allState$trend + 100)/100
mean_whole_trend <- geo_mean(scalled_trend)
variance_whole_trend <- geo_var(scalled_trend)
std_whole_trend <- sqrt(variance_whole_trend)
tmp <- sprintf("The mean year on year rate of the population: %f\nThe variance year on year rate of the population: %f\nThe std year on year rate of the population: %f",mean_whole_trend,variance_whole_trend,std_whole_trend)
cat(tmp)

#states' trend
group_by_state$trend <- scalled_trend
mean_trend_perState <- summarise(group_by_state,geo_mean(trend))
variance_trend_perState <- summarise(group_by_state,geo_var(trend))
std_trend_perState <- summarise(group_by_state,sqrt(geo_var(trend)))
#concatenation
representative_values2 <- merge(mean_trend_perState,variance_trend_perState,by = "state")
representative_values2 <- merge(representative_values2,std_trend_perState,by="state")
names(representative_values2) <- c('state','mean', 'variance','std')
print(representative_values2)

