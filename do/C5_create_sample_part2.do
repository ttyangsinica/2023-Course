
clear

/** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\pic"
*/


** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"
*/

set more off

use "$rawdata\cps_2014_16.dta",replace
replace year=2015 if _n>=20000
replace year=2016 if _n>=40000

save "$rawdata\cps_2014_16.dta",replace



use $rawdata\cps_2014_16.dta,replace

** mvdecode
order ftotval inctot incwage
mvdecode ftotval inctot incwage , mv(9999999 99999999)

** Pay attention to missing variable
gen incwage_test = incwage
replace incwage_test = . if incwage==0
gen largewage=(incwage_test>=30000) if incwage_test!=.
gen largewage1=(incwage_test>=30000)
tab largewage
tab largewage1 

** keep
keep serial year ftotval inctot incwage
keep if year>=2015
keep if inctot != .
keep if (incwage>=30000 & incwage~=50000) | (inctot>=30000 & inctot~=50000)

** drop 
use "$rawdata\cps_2014_16.dta",replace
drop region-county
drop if year==2015
drop if ftotval == .
tostring year,gen(year1)

drop if year1 ~= 2015
drop if year1 ~= "2015"


** _n / _N
keep if _n<=50000
keep if statefip[_n] != statefip[_n-1]
keep if statefip != statefip[_n-1]

use "$rawdata\cps_2014_16.dta",replace
** sort
sort serial year statefip 

** gsort
gsort -year 
gsort -year statefip 

** by/bysort
sort year
by year: sum incwage
bysort year: sum incwage
bysort statefip : keep if _n == 1	

bysort statefip (age): keep if _n == 1	

use "$rawdata\cps_2014_16.dta",replace
bysort statefip: egen state_inc = mean(incwage)
bysort statefip: egen state_inc_sd = sd(incwage)


** collapse
use "$rawdata\cps_2014_16.dta",replace
collapse (mean) incwage, by(statefip year) fast
save "$workdata\state_wage.dta",replace
use "$rawdata\cps_2014_16.dta",replace
collapse (max) max_wage = incwage, by(statefip year)
use "$rawdata\cps_2014_16.dta",replace
gen num=1
collapse (sum) samplesize = num, by(statefip year)
use "$rawdata\cps_2014_16.dta",replace
gen obs=1
collapse (rawsum) samplesize1 = obs, by(year)
save "$workdata\state_size.dta",replace



** append
use "$workdata\state_wage.dta",replace
keep if year==2015
save "$workdata\state_wage_2015.dta",replace

use "$workdata\state_wage.dta",replace
keep if year==2016
save "$workdata\state_wage_2016.dta",replace

use "$workdata\state_wage_2015.dta",replace
append using "$workdata\state_wage_2016.dta"
save "$workdata\state_wage_2015_16.dta",replace


** merge
use "$workdata\state_size.dta",replace

use "$workdata\state_wage_2015_16.dta",replace
merge m:1 year using "$workdata\state_size.dta"
tab _merge


** order
use "$rawdata\cps_2014_16.dta",replace
order *, alphabet
order incwage year, first
order incwage, after(year)

** fillin
use "$workdata\state_wage.dta",replace
fillin statefip year
drop _fillin
//drop if year==2015 & statefip == 18


** expand
expand 2
sort statefip year

/** expand/fillin
drop if year==2015
expand 2 if _n==1
replace year=2015 if _n==_N
replace incwage=. if _n==_N
fillin statefip year

** ipolate
use "$workdata\state_wage.dta",replace
replace incwage=. if year==2015 & statefip == 18
ipolate incwage year, gen(ipincwage)
*/

** reshape
** long formats
use "$workdata\state_wage.dta",replace

reshape wide incwage, i(statefip) j(year)

save "$workdata\state_wage_wide.dta",replace

reshape long incwage, i(statefip) j(year)
