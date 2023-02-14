### Clear R environment
rm(list=ls(all=TRUE))

# Remember that you must use the forward slash / or double backslash \\ in R!

# create log file
# If you use this command (sink), all results will be stored in log file but not showed up in the Console
#sink("D:\\nest\\Dropbox\\causal_data_course\\2018_spring\\Class_Data\\R_code\\R_log\\C6_log.txt")

# get the path for Working directory
getwd()

# Set the working directory
#setwd("C:\\nest\\Dropbox\\Courses\\Causal_Inference_Big_Data\\Slides\\R\\slides\\R_C6_graph")
setwd("C:/nest/Dropbox/causal_data_course/code/Class_Data/rawdata/")
#setwd("C:/nest/Dropbox/causal_data_course/2018_spring/Class_Data/rawdata/")


install.packages("ggplot2")

library(ggplot2)

# Read Data (CSV) (R's default package can help you do it)
acs_2015_csv <- read.csv("acs_2015.csv",header = TRUE,sep = ",")

# Replace original value
acs_2015_csv$inctot[acs_2015_csv$inctot>=9999999] <- NA
acs_2015_csv$incwage[acs_2015_csv$incwage>=9999999] <- NA
acs_2015_csv$ftotinc[acs_2015_csv$ftotinc>=9999999] <- NA

acs_2015_csv <- subset(acs_2015_csv,ftotinc!="NA" | inctot!="NA" | incwage!="NA")


# Label your variables
acs_2015_csv$sex <- factor(acs_2015_csv$sex,levels=c(1,2),labels=c("Male","Female"))
acs_2015_csv$marst <- factor(acs_2015_csv$marst,levels=c(1,2,3,4,5,6),labels=c("Married, spouse present","Married, spouse absent", "Separated", "Divorced", "Widowed", "Single"))


# For more information, please see this link 
# http://r-statistics.co/ggplot2-cheatsheet.html

# geom function: https://ggplot2.tidyverse.org/reference/#section-layer-geoms

# Two Variables (continuous x , continuous y)
# acs_inc_finc_pic must be a dataframe that contains all information to make the ggplot. 
acs_inc_finc_pic <- ggplot(data=acs_2015_csv, aes(x=inctot, y=ftotinc))
acs_inc_finc_pic
ggsave("inc_scatter_1.png", width=4.25,height = 3.25)


# Plot will show up only after adding the geom layers
acs_inc_finc_pic <- ggplot(data=acs_2015_csv, aes(x=inctot, y=ftotinc))
acs_inc_finc_pic +geom_point()
ggsave("inc_scatter_2.png", width=4.25,height = 3.25)


# Specify aesthetics for specific layer
acs_inc_finc_pic <- ggplot(data=acs_2015_csv)
acs_inc_finc_pic +geom_point(aes(x=inctot, y=ftotinc))
ggsave("inc_scatter_3.png", width=4.25,height = 3.25)


# Static setting: point size, shape, color and boundary thickness
# 'stroke' controls the thickness of point boundary
acs_inc_finc_pic <- ggplot(data=acs_2015_csv, aes(x=inctot, y=ftotinc))
acs_inc_finc_pic +geom_point(size=1, shape=1, color="blue", stroke=1)
ggsave("inc_scatter_4.png", width=4.25,height = 3.25)



# Add Title, X and Y axis labels
acs_inc_finc_pic +geom_point(size=1, shape=1, color="blue", stroke=1)+labs(x="Individual Income", y="Family Income", title="The Relationship Between Family Income and Individual Income")
ggsave("inc_scatter_6.png", width=5.25,height = 5.25)

# Change title face, color, line height
acs_inc_finc_pic +geom_point()+ theme(plot.title=element_text(face="bold", color="blue", lineheight=1.2))+labs(x="Individual Income", y="Family Income", title="The Relationship Between Family Income and Individual Income")
ggsave("inc_scatter_7.png", width=5.25,height = 5.25)

# Change title, X and Y axis label and text size
# lot.title: Controls plot title. 
# axis.title.x: Controls X axis title 
# axis.title.y: Controls Y axis title 
# axis.text.x: Controls X axis text 
# axis.text.y: Controls y axis text
acs_inc_finc_pic +geom_point()+ theme(plot.title=element_text(size=15), axis.title.x=element_text(size=12), axis.title.y=element_text(size=12), axis.text.x=element_text(size=15), axis.text.y=element_text(size=15))+labs(x="Individual Income", y="Family Income", title="The Relationship Between Family Income and Individual Income")
ggsave("inc_scatter_8.png", width=5.25,height = 5.25)

# Change point color
acs_inc_finc_pic +geom_point(aes(color=sex))+scale_colour_manual(name="Gender", values = c("blue", "red"))
ggsave("inc_scatter_9.png", width=5.25,height = 5.25)

# Adjust X and Y axis limits
acs_inc_finc_pic +geom_point()+ coord_cartesian(xlim=c(0,50000), ylim=c(0, 500000))
ggsave("inc_scatter_10.png", width=5.25,height = 5.25)


# Change X and Y axis labels
#acs_inc_finc_pic +geom_point()+ coord_cartesian(xlim=c(0,50000), ylim=c(0, 500000))+  scale_x_continuous(breaks=seq(0, 10000, 50000))+  scale_y_continuous(breaks=seq(0, 100000, 500000))
#ggsave("inc_scatter_1.png", width=3.25,height = 3.25)


# Add more layers
acs_inc_finc_pic +geom_point()+geom_smooth(method='lm')+labs(x="Individual Income", y="Family Income", title="The Relationship Between Family Income and Individual Income")
ggsave("inc_scatter_11.png", width=5.25,height = 5.25)

# One variable Graphs
# Density graph
acs_inc_pic <- ggplot(data=acs_2015_csv)

acs_inc_pic + geom_density(kernel="gaussian", aes(x=ftotinc, color=sex)) + labs(x="Income", y="Density", title="Distribution of Family Income")
ggsave("inc_density_4.png", width=5.25,height = 5.25)


wage_mean <-mean(acs_2015_csv$incwage)
acs_inc_pic + geom_density(kernel="gaussian", aes(x=ftotinc, color=sex)) + geom_vline(xintercept=wage_mean, linetype="dashed",color="black")+ labs(x="Income", y="Density", title="Distribution of Family Income")
ggsave("inc_density_5.png", width=5.25,height = 5.25)

# Bar graph

acs_gender_pic_bar <- ggplot(data=acs_2015_csv)
acs_gender_pic_bar + geom_bar(aes(x=sex)) + labs(x="Gender", y="Number of Observations", title="Distribution of Gender")
ggsave("inc_bar_1.png", width=5.25,height = 5.25)




