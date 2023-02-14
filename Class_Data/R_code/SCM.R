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



#########################################################
# Sythetic Control
install.packages("Synth") 
install.packages("MSCMT")



rm(list=ls()) # Remove all items in the enviroment

##### 1.Read raw Data ##### 
library(Synth)
# Load the "basque" dataset
# The dataset contains information from 1955--1997 on 17 Spanish regions. It was used by Abadie and Gardeazabal (2003).
# Abadie, Alberto, and Javier Gardeazabal. "The economic costs of conflict: A case study of the Basque Country." American economic review 93, no. 1 (2003): 113-132.
data(basque)
#write_dta(basque, "basque.dta", version = 14)


##### 2. Transform to Matrix Format ##### 
library(MSCMT) # Multivariate Synthetic Control Method Using Time Series
# Generates a list of matrices from a long format dataset (basque)
Basque <- listFromLong(basque, unit.variable="regionno", time.variable="year", unit.names.variable="regionname")

names(Basque) # There are 14 matrices of regions' time-series characteristics
colnames(basque) # The ?€˜long?€? format dataset has 17 vaieables (region number, region name, year, and 14 characteristics)
head(Basque$gdpcap) # listFromLong changes dataset into matrix format: 43 years * 18 regions (17 subregions + Spain as a whole)

##### 3. Calculate Education Level Distribution ##### 
# define the sum of all cases (Sum of all levels of education: illiterate, primary, highschool, tertiary... )
school.sum <- with(Basque,colSums(school.illit + school.prim + school.med + school.high  + school.post.high))

# combine school.high and school.post.high in a single class (higher than high school)
Basque$school.higher <- Basque$school.high + Basque$school.post.high

# calculate ratios and multiply by number of observations to obtain percentages from totals 
for (item in c("school.illit", "school.prim", "school.med", "school.higher")){
  Basque[[item]] <- 6 * 100 * t(t(Basque[[item]]) / school.sum)
}

# Note: The equation times six because the denominator is the sum of 6 years population while the numerator is 1 year population.
#       Notice in the equation defining school.sum, it sums by column (regions) but not by rows (years) or cells.
#       But, maybe a better solution is to calculate the denominator by only sum up 1-year population.


##### 4. Define Treatment Group and Control Group #####
# Treatment Group: Basque Country, a country with terrorism
treatment.identifier <- "Basque Country (Pais Vasco)"
# Control Group: The rest of the spain (exclude Basque and Spain)
controls.identifier  <- setdiff(colnames(Basque[[1]]),
                                c(treatment.identifier, "Spain (Espana)"))

##### 5. Define Dependent Variable and Predict Variables #####
# Dependent Variable: real GDP per capita (in 1986 USD, thousands)
times.dep  <- cbind("gdpcap"                = c(1960,1969))
# Control Varaible
times.pred <- cbind("invest"                = c(1964,1969), # gross total investment as a share of GDP
                    "gdpcap"                = c(1960,1969), # real GDP per capita (in 1986 USD, thousands)
                    "sec.agriculture"       = c(1961,1969), # production in agriculture, forestry, and fishing sector as a percentage of total production
                    "sec.energy"            = c(1961,1969), # production in energy and water sector as a percentage of total production
                    "sec.industry"          = c(1961,1969), # production in industrial sector as a percentage of total production
                    "sec.construction"      = c(1961,1969), # production in construction and engineering sector as a percentage of total production
                    "sec.services.venta"    = c(1961,1969), # production in marketable services sector as a percentage of total production
                    "sec.services.nonventa" = c(1961,1969), # production in Nonmarketable services sector as a percentage of total production
                    "popdens"               = c(1969,1969)) # population density (persons per square kilometer)

# Creat a character vector containing one name of an aggregation function for each predictor variable (here use "mean")
agg.fns <- rep("mean", ncol(times.pred)) 

##### 6. Estimation and Graphing #####
# SCM estimation
res <- mscmt(Basque, treatment.identifier, controls.identifier, times.dep, times.pred, agg.fns, seed=1)

# display results
# The optimal weghtings are: Baleares (Islas): 21.92728%, Cataluna: 63.27859%, Madrid (Comunidad De): 14.79413%
res

# plot results
library(ggplot2)
# Plot the trends comparison of gdpcap (real GDP per capita) of actual data (Basque County) and synthsized data (Synthetic Basque County)
ggplot(res, type="comparison")
# Plot the gap of gdpcap (real GDP per capita) of actual data (Basque County) and synthsized data (Synthetic Basque County)
ggplot(res, type="gaps")
# Plot the other variables
ggplot(res, what=c("gdpcap","invest","school.higher","sec.energy"), type="comparison")

##### 7. Placebo test an P-value Calculation #####
# get p-value
library(parallel)
#cl <- makeCluster(2) # Creates a set of copies of R running in parallel and communicating over sockets.
# Run the Placebo Test
#resplacebo <- mscmt(Basque, treatment.identifier, controls.identifier, times.dep, times.pred, agg.fns,  cl=cl, placebo=TRUE, seed=1)
resplacebo <- mscmt(Basque, treatment.identifier, controls.identifier, times.dep, times.pred, agg.fns,  placebo=TRUE, seed=1)


#stopCluster(cl)

# Report the p-value
pvalue(resplacebo, exclude.ratio=5, ratio.type="mspe", alternative="less")
# exclude.ratio: Exclude control units with large pre-treatment errors (an average pre-treatment gap of more then exclude.ratio times)
# Here set to five (only 13 among total 16 control units are included)
# ratio.type: Use "rmspe" for root mean squared errors, or "mspe" for mean squared errors are considered
# alternative: Specify type "p.value". Either "two.sided" (default), "less", or "greater".

# Graph a comparison plot which treats Cataluna as treatment group
ggplot(resplacebo[["Cataluna"]], type="comparison")

# Plot all 17 regions
ggplot(resplacebo)
# Plot only control units with pre-treatment errors less than 5 times of average pre-treatment gap
ggplot(resplacebo, exclude.ratio=5, ratio.type="mspe")
# Plot p-value
ggplot(resplacebo, exclude.ratio=5, ratio.type="mspe", type="p.value", alternative="less")

##### 8. Calculating the Aggregated Treatment Effect (DID) #####
did(resplacebo, range.post=c(1970,1990), exclude.ratio=5, alternative="less")
# The effect size is -0.7715269, the p-value is 0.07692308