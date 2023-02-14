
clear


// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"
*/

set more off

use "$rawdata\cps_2014_16.dta",replace


** Examine data
** It is a good idea to examine your data when you first read it into Stata 
** You should check that all the variables and observations are present and in the correct format

** You can see the contents of a data file using the browse or edit command
browse

edit

** describe produces a summary of the dataset in memory or of the data stored in a Stata-format dataset.
describe using "$rawdata\cps_2014_16.dta"


** "list": show entire data within the results window
** Although listing the entire dataset is only feasible if it is small
** Alternatively we could focus on all variables but list only a limited number of observations. For example the observation 55 to 60
** The qualifier "in" ensures that commands apply only to a certain subset of the data 

list serial year sex age
list serial year sex age in 55/60


** A second way of subsetting the data is the “if” qualifier (more on this later on). 
** The qualifier is followed by an expression that evaluates either to “true” or “false” (i.e. 1 or 0).

list serial year sex age if age==37


** With large datasets, it often is impossible to check every single observation using "list"
** "assert": verifies whether a certain statement is true or false
** If the statement is true, "assert" does not yield any output on the screen. 
** If it is false, "assert" gives an error message and the number of contradictions
assert sex<3
assert sex>3
assert age>85

** "codebook": provides extra information on the variables, such as summary statistics of numerics, example data-points of strings, and so on
** "codebook" without a list of variables will give information on all variables in the dataset
codebook age sex incwage
codebook

** "summarize" summary statistics, such as means, standard deviations, and so on
**  Additional information about the distribution of the variable can be obtained using the "detail" option 
sum incwage
sum incwage,d
sum

** "tab": This is a versatile command that can be used, for example, to produce a frequency table of one variable or a cross-tab of two variables
tab age
tab age sex  

** We can use the "tab" command combined with the "sum(varname)" option to gain a quick idea of the descriptive statistics of certain subgroups
** For example, we can know average wage by age (gender)
tab age, sum(incwage)
tab sex, sum(incwage)


** "inspect": This is a way to eyeball the distribution of a variable, including as it does a mini-histogram.
** It is also useful for identifying outliers or unusual values, or for spotting non-integers in a variable that should only contain integers
inspect age
inspect incwage



** isid
isid serial 

** "duplicates":
duplicates report serial 
duplicates report 

duplicates example serial age year in 1/100
duplicates list serial age year in 1/100 
duplicates tag serial,gen(s_repeat) 
order serial s_repeat pernum
tab s_repeat
duplicates drop serial,force 

