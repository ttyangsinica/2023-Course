rm(list=ls(all=TRUE))

# get the path for Working directory
getwd()

# Set the working directory
setwd("C:\\nest\\Dropbox\\causal_data_course\\code\\Class_Data\\rawdata/")

install.packages('MatchIt')
install.packages('haven')

library(MatchIt) # load matching package
library(haven)

options("scipen" =100, "digits" = 4) # override R's tendency to use scientific notation

# raw differences in means for treatments and controls using regression

#data(lalonde)
#write_dta(lalonde, "lalonde.dta", version = 14)

lalonde<- read_dta("lalonde.dta")



lalonde$black[lalonde$race == "black"] <- 1 
lalonde$black[lalonde$race == "hispan"] <- 0 
lalonde$black[lalonde$race == "white"] <- 0 


lalonde$hispan[lalonde$race == "hispan"] <- 1 
lalonde$hispan[lalonde$race == "black"] <- 0 
lalonde$hispan[lalonde$race == "white"] <- 0 





# Step 1 Test Differences in Outcomes in Pre-matching Data
summary(lm(re78~treat,data=lalonde))

# Step 2 Test Differences in Covariates in Pre-matching Data
summary(lm(age~treat,data=lalonde))


#-----------------------------------------------------
# Step 3 nearest neighbor matching via MatchIt
#-----------------------------------------------------

# estimate propensity scores and create matched data set using 'matchit' and lalonde data

# without replacement
m.out1 <- matchit(treat ~ age + educ + black + hispan + nodegree + married + re74 + re75, data = lalonde, method = "nearest", distance = "logit",replace=FALSE)
m.data1 <- match.data(m.out1,distance ="pscore") # create ps matched data set from previous output

summary(lm(re78~treat, data = m.data1))

# with replacement
m.out1 <- matchit(treat ~ age + educ + black + hispan + nodegree + married + re74 + re75, data = lalonde, method = "nearest", distance = "logit",replace=TRUE)
m.data1 <- match.data(m.out1,distance ="pscore") # create ps matched data set from previous output

summary(lm(re78~treat, data = m.data1,weights=weights))


summary(m.out1) # check balance
hist(m.data1$pscore) # distribution of propenisty scores
summary(m.data1$pscore)





