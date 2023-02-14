clear


// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"
*/


capture log close
log using "$log\how_to_use_log", replace text

use "$rawdata\cps_2014_16.dta",replace


** describe produces a summary of the dataset in memory or of the data stored in a Stata-format dataset.
describe using "$rawdata\cps_2014_16.dta"


** "list": show entire data within the results window
** Although listing the entire dataset is only feasible if it is small
** Alternatively we could focus on all variables but list only a limited number of observations. For example the observation 55 to 60
** The qualifier "in" ensures that commands apply only to a certain subset of the data 

list serial year sex age
list serial year sex age in 55/60


log close
