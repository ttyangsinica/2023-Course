### Clear R environment
## removes all objects from the current workspace (R memory)
## You can give rm() a bunch of object to remove using the argument list. 
## Because ls()lists all objects in the current workspace, and you specify it as the list of objects to remove, the aforementioned command removes all objects from the R memory.
rm(list=ls())


# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
# sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C1_log.txt")


# get the path for Working directory
getwd()

# Set the working directory
setwd("C:/nest/Dropbox/causal_data_course/code/Class_Data/rawdata")


# lists available files.
dir()

# Read Data (CSV) (R's default package can help you do it)
acs_2015_csv <- read.csv("acs_2015.csv",header = TRUE,sep = ",")
class(acs_2015_csv)
View(acs_2015_csv)
help(read.csv)

# Transform to csv
write.csv(acs_2015_csv,file="acs_2015_v2.csv")

## check whether you create a new file called "acs_2015_v2.csv"
dir()


# Read Data (txt)
acs_2015_txt <- read.table("acs_2015.txt",header = FALSE,sep = ",")

acs_2015_txt <- read.table("acs_2015.txt",header = TRUE,sep = ",")

# Transform to txt
write.table(acs_2015_txt,file="acs_2015_v2.txt")

## check whether you create a new file called "acs_2015_v2.txt"
dir()

# for Excel
install.packages("readxl")
library(readxl)

# Read Data (excel)
pwt_xlsx <- read_excel("pwt90.xlsx",sheet="Data")
View(pwt_xlsx)


# for Stata or other softwares
install.packages("haven") 
library(haven)

# Read Data (dta, STATA)
pwt_dta <-read_dta("pwt90.dta")
View(pwt_dta)


write_dta(pwt_dta, "pwt_v2.dta", version = 14)

## check whether you create a new file called "pwt_v2.dta"
dir()

?read_dta


# save to rda file
save(acs_2015_csv, file = "acs_2015.rda")

# load rda file
load("acs_2015.rda")

# remove "object"
remove(acs_2015_txt)

# remove data file
file.remove("acs_2015.rda")




# for Stata 13 above
#install.packages("readstata13")
#library(readstata13)


# Read Data (dta, STATA)
#pwt_dta <- read.dta13("pwt90.dta")


#install.packages("foregin")
#library(foregin)


# Transform to dta
#pwt_dta_f <-read.dta(pwt_dta,file="pwt.dta")


# Transform to dta
#write.dta(pwt_dta_f,file="pwt_v3.dta")















