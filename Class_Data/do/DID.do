clear


** please change your path
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"
*/


/** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\pic"
*/


set more off

use "$rawdata\eitc.dta",replace


** Step 1: Define treatment and control groups
** construct a dummy for treatment group and post-treatment period

** a dummy for treatment group
gen anykids = (children >= 1)

** a dummy for post-treatment period
gen post93 = (year >= 1994)

** treatment variable (DID key variable)
gen eitc = post93*anykids


** Step 2: Graphical Analysis 
** generate time trend in outcome ("work") for treatment and control group ("anykids")
collapse (mean) work, by(year anykids)

** for control group
gen work0 = work if anykids==0
label var work0 "Single women, no children"

** for treatment group
gen work1 = work if anykids==1
label var work1 "Single women, children"
		
** graph outcome by group
twoway (line work0 year, sort) (line work1 year, sort), ytitle(Labor Force Participation Rates)
graph export "$pic\eitc_DID.png", replace width(3000)


use "$rawdata\eitc.dta",replace

** a dummy for treatment group
gen anykids = (children >= 1)

** a dummy for post-treatment period
gen post93 = (year >= 1994)

** treatment variable (DID key variable)
gen eitc = post93*anykids


** Step 3: Show the group means in the pre/post-treatment period
** pre-treatment
mean work if post93==0 & anykids==0
mean work if post93==0 & anykids==1

** post-treatment
mean work if post93==1 & anykids==0
mean work if post93==1 & anykids==1


** Step 4: DID regression
reg work post93 anykids eitc,r

** add more variables
gen age2 = age^2          /*Create age-squared variable*/
gen nonlaborinc = finc - earn     /*Non-labor income*/

reg work post93 anykids eitc nonwhite age age2 ed finc nonlaborinc,r

** treatment intensity
gen onekid = (children==1) 
gen twokid = (children>=2)
gen eitc_one = post93*onekid
gen eitc_two = post93*twokid

reg work post93 onekid twokid eitc_one eitc_two nonwhite age age2 ed finc nonlaborinc,r


** Step 5: Placebo Test
** Testing a placebo model is when you arbitrarily choose a treatment time before your actual treatment time, and test to see if you get a significant treatment effect.
gen placebo = (year >= 1992)
gen placeboXany = anykids*placebo

reg work anykids placebo placeboXany if year<1994

** Or you can conduct a leads and lags DID regression to analyze pre-treatment trend
** generate dummaies and their interaction terms

reg work i.year##i.anykids  nonwhite age age2 ed finc nonlaborinc,r

