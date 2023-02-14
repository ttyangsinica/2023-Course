### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C3_log.txt")


# get the path for Working directory
getwd()

# Set the working directory
setwd("C:/nest/Dropbox/causal_data_course/code/Class_Data/rawdata")

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


# sort observations
acs_2015_csv<-arrange(acs_2015_csv,incwage)

acs_2015_csv<-arrange(acs_2015_csv,-incwage)



# keep some observations with specific criteria
acs_2015_csv_male_h <- filter(acs_2015_csv, sex==1 & ftotinc>=50)

acs_2015_csv <- filter(acs_2015_csv, sex==1 & ftotinc>=50000)

#acs_2015_csv <- filter(acs_2015_csv, substr(state_name, 1, 1) == "A")


# select variable
acs_2015_csv_test <- select(acs_2015_csv, X:ftotinc)

acs_2015_csv_new <- select(acs_2015_csv, year,sex)


acs_2015_csv <- select(acs_2015_csv_test, -X,-age,-sex)


# Make new variables
acs_2015_csv<-mutate(acs_2015_csv,log_ftotinc=log(ftotinc))

acs_2015_csv<-mutate(acs_2015_csv,tot_inc=ftotinc+incwage)

acs_2015_csv<-mutate(acs_2015_csv_new,sex=recode(sex,`1`="0",`2`="1"))

acs_2015_csv<-mutate(acs_2015_csv_new,sex=recode(sex,`1`="female",`0`="male"))

acs_2015_csv<-mutate(acs_2015_csv,first_word = substr(sex, 1, 1))

acs_2015_csv<-rename(acs_2015_csv,wage=incwage)



# Create group statistics
acs_2015_csv_group<-summarise(group_by(acs_2015_csv, region), m = mean(ftotinc), sd = sd(ftotinc))

acs_2015_csv_group2<-summarise(group_by(acs_2015_csv, region, year), m = mean(ftotinc), sd = sd(ftotinc))

acs_2015_csv_group3<-summarise(group_by(acs_2015_csv, sex), m = mean(ftotinc), sd = sd(ftotinc))


# merge
acs_2015_csv_new<-full_join(acs_2015_csv,acs_2015_csv_group, by = "region")

acs_2015_csv_new2<-full_join(acs_2015_csv,acs_2015_csv_group2, by = c("region","year"))

acs_2015_csv_new3<-inner_join(acs_2015_csv,acs_2015_csv_male_h, by = "X")

acs_2015_csv_new4<-left_join(acs_2015_csv,acs_2015_csv_male_h, by = "X")

acs_2015_csv_new5<-right_join(acs_2015_csv,acs_2015_csv_male_h, by = "X")

# append
acs_2015_csv_new6<-bind_rows(acs_2015_csv,acs_2015_csv_male_h)

# use %>%   
acs_2015_csv %>% filter(sex==1 & ftotinc>=50) %>% 
  mutate(log_ftotinc=log(ftotinc))
