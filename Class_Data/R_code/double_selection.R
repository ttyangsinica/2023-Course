###############################
# LASSO (Double Selection) and Causal inference

### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C5_log.txt")

# get the path for Working directory
getwd()

# Set the working directory
#setwd("C:\\nest\\Dropbox\\Courses\\Causal_Inference_Big_Data\\Slides\\R\\slides\\R_C5_analyze_data")
setwd("C:\\nest\\Dropbox\\causal_data_course\\code\\Class_Data\\rawdata/")
#setwd("C:/nest/Dropbox/causal_data_course/2018_spring/Class_Data/rawdata/")




install.packages("hdm") 
install.packages('haven')

library(hdm)
library(haven)

GrowthData<- read_dta("growth.dta")

dim(GrowthData)

y = GrowthData[, 1, drop = F]
d = GrowthData[, 2, drop = F]
X = as.matrix(GrowthData)[, -c(1, 2)]
varnames = colnames(GrowthData)


doublesel.effect = rlassoEffect(x = X, y = y, d = d, method = "double selection")

summary(doublesel.effect)
confint(doublesel.effect)
print(doublesel.effect)
plot(doublesel.effect)
