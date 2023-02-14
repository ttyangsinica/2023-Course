### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C5_log.txt")

# get the path for Working directory
getwd()

# Set the working directory
setwd("C:\\nest\\Dropbox\\causal_data_course\\code\\Class_Data\\rawdata/")

# change libaryªº¸ô®|
#.libPaths("C:/R")


#########################################
# RDD
## Install RDD packages
install.packages('rdrobust')
install.packages('haven')


library(rdrobust)
library(haven)

# Read Data (dta, STATA)
RDD_LMB_data<- read_dta("RDD-LMB-data.dta")


summary(RDD_LMB_data)

# Step 1: Graphical Analysis
# outcome variable

rdplot(y=RDD_LMB_data$score, x=RDD_LMB_data$demvoteshare, binselect="es", ci=95, c=0.5, p=1, h=0.5, title="RD Plot: U.S. Senate Election Data")

RDD_LMB_data$ivy_leg<-0
RDD_LMB_data$ivy_leg[RDD_LMB_data$collegeattend ==1] <- 1 

# other covariates
rdplot(y=RDD_LMB_data$pres_dem_pct, x=RDD_LMB_data$demvoteshare, binselect="es", ci=95, c=0.5, h=0.5, title="RD Plot: U.S. Senate Election Data")

## Step 2: test sorting behavior

install.packages('rdd')

library(rdd)

DC_test<-DCdensity(RDD_LMB_data$demvoteshare,0.5)

summary(DC_test)

## Step 3: Preparation for Estimation
RDD_LMB_data$democrat[RDD_LMB_data$demvoteshare>=0.5] <- 1 
RDD_LMB_data$democrat[RDD_LMB_data$demvoteshare<0.5] <- 0 

RDD_LMB_data$x_c <- RDD_LMB_data$demvoteshare - 0.5
RDD_LMB_data$x2_c <- RDD_LMB_data$x_c^2

RDD_LMB_data$d_x_c <- RDD_LMB_data$democrat*RDD_LMB_data$x_c
RDD_LMB_data$d_x2_c <- RDD_LMB_data$democrat*RDD_LMB_data$x2_c


## Step 4: Implement Estimation
rdd_lm <- lm(score ~ democrat+x_c+x2_c+d_x_c+d_x2_c,data=RDD_LMB_data)

summary(rdd_lm)


### rdrobust
rdd_robust<-rdrobust(y=RDD_LMB_data$score, x=RDD_LMB_data$x_c)
summary(rdd_robust)

### rdrobust with all estimates
summary(rdrobust(y=RDD_LMB_data$score, x=RDD_LMB_data$x_c,all=TRUE))

## rdrobust backward compatibility
summary(rdrobust(y=RDD_LMB_data$score, x=RDD_LMB_data$x_c, h=0.05))

