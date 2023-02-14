### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C3_log.txt")


# get the path for Working directory
getwd()

# Set the working directory
setwd("C:/nest/Dropbox/causal_data_course/code/Class_Data/rawdata/")
#setwd("C:/nest/Dropbox/causal_data_course/2018_spring/Class_Data/rawdata/")

# Read Data (CSV) (R's default package can help you do it)
acs_2015_csv <- read.csv("acs_2015.csv",header = TRUE,sep = ",")

# show the variable names in this dataset
names(acs_2015_csv)

# summary statistics
summary(acs_2015_csv)


# Install dplyr
install.packages("tidyverse")
library(tidyverse)

install.packages("dplyr")
library(dplyr)



# distinct
acs_2015_csv_dis<-distinct(acs_2015_csv)

acs_2015_csv_dis_age<-distinct(acs_2015_csv, age, .keep_all = TRUE)

# check missing value in dataset
# Replace original value
acs_2015_csv$incwage[acs_2015_csv$incwage>=999999] <- NA
acs_2015_csv$inctot[acs_2015_csv$inctot==9999999] <- 0

