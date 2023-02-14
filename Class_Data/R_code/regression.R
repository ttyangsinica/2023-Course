### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C5_log.txt")

# get the path for Working directory
getwd()

# Set the working directory
#setwd("C:\\nest\\Dropbox\\Courses\\Causal_Inference_Big_Data\\Slides\\R\\slides\\R_C6_graph")
setwd("C:\\nest\\Dropbox\\causal_data_course\\code\\Class_Data\\rawdata/")
#setwd("C:/nest/Dropbox/causal_data_course/2018_spring/Class_Data/rawdata/")

# Read Data (CSV) (R's default package can help you do it)
acs_2015_csv <- read.csv("acs_2015.csv",header = TRUE,sep = ",")

# OLS
# use linear regression to estimate the model
acs_lm <- lm(incwage ~ age+sex,data=acs_2015_csv)

# show the estimated results
summary(acs_lm)



