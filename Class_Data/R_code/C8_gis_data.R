### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C6_log.txt")

# get the path for Working directory
getwd()

# Set the working directory
#setwd("D:\\nest\\google_drive\\Courses\\Causal_Inference_Big_Data\\Slides\\R\\slides\\R_C6_graph")
setwd("C:/nest/Dropbox/causal_data_course/2020_spring/Class_Data/rawdata/map_data")
#setwd("C:/nest/Dropbox/causal_data_course/2018_spring/Class_Data/rawdata/")

install.packages("rgdal")
install.packages("rgeos")
#install.packages("PBSmapping")


library("rgdal")
library("rgeos")
#library("PBSmapping")

# 1. Taiwan's map
tw_map<- readOGR("C:/nest/Dropbox/Courses/Causal_Inference_Big_Data/Slides/L10_spatial_data_analysis/STATA_R_Example/map_data", "TW_town",encoding="UTF-8")

# plots the shapefile
plot(tw_map, axes=TRUE)

# explore spatial data
class(tw_map)
summary(tw_map)
tw_map_attr <- tw_map@data
head(tw_map_attr)


# 2. plot subset of Taiwan: Taipei city
TPE_index <- c(170:181)

plot(tw_map[TPE_index,],  col = "tomato")
plot(tw_map[177,],  col = "tomato")

TPE <- tw_map[TPE_index,]
plot(TPE,  col = "tomato")

TPE <- tw_map[tw_map$County_ID==63,]
plot(TPE,  col = "tomato")


# 3. generate Shape file for Taipei city
writeOGR(TPE, ".", "Taipei", driver="ESRI Shapefile",overwrite_layer=TRUE)


# 4. Mapping data in R
install.packages("sf")
install.packages("sp")
install.packages("tmap")
install.packages("leaflet")
install.packages("foreign")
#install.packages("GISTools")


library(sf)
library(sp)
library(tmap)
library(leaflet)
library(foreign)
library(haven)
library(dplyr)
#library(GISTools)

# 4-1 merge housing price with shape file

# get housing price data from outside dataset
TW_h_price <- read_dta("h_price_2015.dta")

TW_h_price$h_price_pi <-TW_h_price$h_price_pin/10000

# merge housing price data with shape file (TPE) 
TPE_db_h_price <- merge(TPE, TW_h_price, by.x="Town_ID", by.y="Town_ID")

# 4-2. Draw a map (housing price in Taipei)
tm_shape(TPE_db_h_price) + tm_borders()

tm_shape(TPE_db_h_price) + tm_borders() + tm_fill("h_price_pi")

TPE_h_price_g<-tm_shape(TPE_db_h_price) + tm_borders() + tm_fill("h_price_pi", title = "House Price", style = "quantile", n = 6, palette = "Reds") + tm_layout(title = "Taipei", title.position = c("0.7", "0.9"),legend.text.size = 0.3,legend.title.size = 0.3, legend.position = c("0.7", "0.7"), frame = FALSE)
   
# 5. save graph

tmap_save(TPE_h_price_g, filename = "TPE_h_price_g.png")

