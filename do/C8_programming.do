clear 

// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\pic"
*/

capture log close
log using "$log\C8_programming", replace text
set more off


use "$rawdata\cps_2014_16.dta",clear


** locoal
local Lvarlist region age sex race health
reg incwage `Lvarlist',r 
reg inctot `Lvarlist',r   

local Lvarlist region age sex race health
reg inctot `Lvarlist',r 

** global
global Gvarlist region age race
reg incwage $Gvarlist,r 
reg inctot $Gvarlist,r 


local year15 “if year==2015”
local year15 if year==2015
reg incwage $Gvarlist `year15',r 


decode statefip,gen(statename)
local stfirst "m"
reg incwage $Gvarlist if substr(statename,1,1)=="`stfirst'"
//reg incwage $Gvarlist if statename=="`stfirst'"

** tempvar
tempvar logwage
gen `logwage'=log(incwage)  
reg `logwage' $Gvarlist,r 

sum incwage if  `logwage'>=8

** tempfile
tempfile cpsage
collapse (mean) age, by(statefip)
save "`cpsage'"
merge 1:m statefip using "$rawdata\cps_2014_16.dta" 


** foreach
foreach x in auto.dta auto2.dta {
sysuse "`x'", clear
tab foreign, missing
}


foreach x in mpg weight {
summarize `x'
}




use "$rawdata\cps_2014_16.dta",replace
decode statefip,gen(statename)
local stfirst "m w s"
foreach x of local stfirst {
reg incwage $Gvarlist if substr(statename,1,1)=="`x'"
}



foreach x in 50 53 70 {
reg incwage $Gvarlist if age == `x'
}



** forvalues
forvalues i = 2014(1)2016 {
reg incwage $Gvarlist if year==`i'
}


** while
local i=2014
while `i'<=2016 {
reg incwage $Gvarlist if year==`i'
local i = `i' + 1
}


** if....else
local i=2014
while `i'<=2016 {
  if `i'==2014 {

  reg incwage $Gvarlist if sex==1
               }
  else {
   
  reg incwage $Gvarlist if sex==2
 
  }
local i = `i' + 1
}






** create your own program
capture program drop mymean 
program define mymean 
egen mean_`1'=mean(`1')  
tab mean_`1'  
end  

mymean inctot

capture program drop mymean2  
program define mymean2 
  while "`1'"~="" {  
    quietly egen `1'_mean = mean(`1')  
    display "Mean of `1' = " `1'_mean  
    macro shift  
  }  
end  

mymean2 inctot incwage





