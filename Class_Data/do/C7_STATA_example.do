clear all
set more off

clear

/** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\pic"
*/

** please change your path
global do = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\pic"
*/

ssc install tidy  // for command gather

import delimited $rawdata/CAGDP1.csv, encoding(UTF-8) clear delimiters(",") rowrange(5:) varnames(5)


gather v3-v21, label(year) variable(year_drop) value(GDP)

drop year_drop

destring year, replace

