clear

** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\pic"
*/

capture log close
log using "$log\ttest", replace text
set more off

use "$rawdata\cps_2014_16.dta"

ttest incwage, by(sex)

ttest age = 30 if sex==1 

log close
