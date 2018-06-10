#set path(path have been already set)
print(getwd())

#set libraries
print(search())
library("gdata") #to read xls data

#load data
population = read.xls("2015_population.xls")
#delete useless columns
population = population[c("X.5","X.6","X.7")] #dataframe of 3 factors
c_name = c("state","city","population") #to set columns name
names(population) <- c_name
print(names(population))

population <- population[11:length(population[[2]]),] #delete useless values
sapply(gsub(',','',population$population),function(x) x[1]) # to eliminate comma on population column