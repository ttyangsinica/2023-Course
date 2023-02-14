### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C5_log.txt")

# get the path for Working directory
getwd()

# Set the working directory
setwd("C:\\nest\\Dropbox\\Courses\\Causal_Inference_Big_Data\\Slides\\R\\slides\\R_C5_analyze_data")

setwd("C:\\nest\\Dropbox\\causal_data_course\\code\\Class_Data\\rawdata/")

# change libaryªº¸ô®|
#.libPaths("C:/R")

#.libPaths()

pkgs <- c("magrittr", "dplyr")
install.packages(pkgs)

install.packages('haven')
install.packages('ggplot2')

library(haven)
library(ggplot2)


eitc_data<- read_dta("eitc.dta")

summary(eitc_data)

# Step 1: Define treatment and control groups
# construct a dummy for treatment group and post-treatment period

# a dummy for treatment group
eitc_data$anykids[eitc_data$children >=1] <- 1 
eitc_data$anykids[eitc_data$children ==0] <- 0 	

# a dummy for post-treatment period
eitc_data$post93[eitc_data$year >=1994] <- 1 
eitc_data$post93[eitc_data$year <1994] <- 0 

# treatment variable (DID key variable)
eitc_data$eitc<-eitc_data$post93*eitc_data$anykids

eitc_data$anykids <- factor(eitc_data$anykids,levels=c(0,1),labels=c("No kid","Have kids"))

# Step 2: Graphical Analysis 
# generate time trend in outcome ("work") for treatment and control group ("anykids")
ggplot(eitc_data, aes(x=year, y=work, color = anykids)) +stat_summary(geom = 'line') +geom_vline(xintercept = 1994) +theme_minimal()
ggsave("eitc_did.png", width=5.25,height = 5.25)


# Step 3: DID regression# Step 4: Placebo Test
# Testing a placebo model is when you arbitrarily choose a treatment time before your actual treatment time, and test to see if you get a significant treatment effect.

DID <- lm(work ~ anykids+post93+eitc, data = eitc_data)
summary(DID)


eitc_data <- eitc_data[eitc_data$year<1994,]

eitc_data$placebo[eitc_data$year >=1992] <- 1 
eitc_data$placebo[eitc_data$year <1992] <- 0 


eitc_data$anykids_p[eitc_data$children >=1] <- 1 
eitc_data$anykids_p[eitc_data$children ==0] <- 0 

eitc_data$placeboXany<-eitc_data$placebo*eitc_data$anykids_p

DID_placebo <- lm(work ~ anykids_p+placebo+placeboXany, data = eitc_data)
summary(DID_placebo)



