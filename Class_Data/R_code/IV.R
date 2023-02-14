
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



##########################################
# IV regression

install.packages("AER")

library(AER)

# Loads specified data sets
data("CigarettesSW", package = "AER")

# generate some useful variables
CigarettesSW$rprice <- CigarettesSW$price/CigarettesSW$cpi
CigarettesSW$rincome <- CigarettesSW$income/CigarettesSW$population/CigarettesSW$cpi
CigarettesSW$tdiff <- with(CigarettesSW, (taxs - tax)/cpi)


# IV restults
fm_sec <- (log(packs) ~ log(rprice) + log(rincome) | log(rincome) + tdiff ,
           data = CigarettesSW, subset = year == "1995")

summary(fm_sec, diagnostics = TRUE)

# First stage results
fm_first <- lm(log(rprice)~log(rincome) + tdiff,data = CigarettesSW, subset = year == "1995")

summary(fm_first)