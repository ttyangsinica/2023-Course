clear

// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"
*/


/** please change your path
global do = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "D:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\pic"
*/

set more off

use "$rawdata\cps_2014_16.dta",replace


** Organising dataset

** Create variables

** "gen": creating new variables
** A couple of things to note: 
** First, Stata‟s default data type is float, so if you want to create a variable in some other format (e.g. byte, string), you need to specify this.
** Second, missing numeric observations, denoted by a dot, are interpreted by Stata as a very large positive number. 
** You need to pay special attention to such observations when using if statements
gen age_sq = age^2
gen log_incwage = log(incwage)
gen number=10 /* constant value of 10 */
gen id=_n    /* id number of observation */
gen total=_N /* total number of observations */
gen bigyear=year if incwage> 100000 /* show the year if income > 100000 */

gen str6 source="CPS" /* string variable */
replace incwage =. if incwage==9999999   /* replace 9999999 to missing */

** "egen": this command typically creates new variables based on summary measures, such as sum, mean, min and max:
** Missing values are handled by "egen" will simply be ignored.

egen year_inc=total(incwage), by(year) /* sum of the population per year */
egen state_inc=mean(incwage), by(statefip) /* mean of the income by state */
order statefip state_inc
sort statefip

egen count_id=count(id) /* counts number of obs */
egen g_state_county=group(statefip region) /* generates numeric id variable for state and county */
order statefip region g_state_county

egen diff_v =  diff(incwage inctot)
order incwage inctot diff_v

help egen

** The "egen" command is also useful if your data is in long format (see below) and you want to do some calculations on different observations, 
** e.g. year is long, and you want to find the difference between 1995 and 1998 populations. 
** The following routine will achieve this:
keep if year==2015
gen temp1=incwage 
egen temp2=max(temp1), by(statefip)
gen temp3=incwage-temp2
egen diff=max(temp3), by(statefip)

order incwage temp1 temp2 temp3

drop temp*


** Note that both "gen" and "egen" have sum functions. 
** "egen" generates the total sum, and "gen" creates a cumulative sum. 
** The running cumulation of gen depends on the order in which the data is sorted, so use it with caution
** To avoid confusion you should use the total function rather than sum for "egen". 
** It will give you the same result and in fact the sum function in "egen" is not documented.
use "$rawdata\cps_2014_16.dta",replace


egen totpop=sum(incwage) /* sum total of income = single result*/
gen cumpop=sum(incwage) /* cumulative total of income */

egen totpop2 = total(incwage)

** "replace": this command modifies existing variables in exactly the same way as generate creates new variables
** Note that if you apply a transformation to missing data, the result will still be a missing value. 
** A transformation that is undefined, e.g. taking the natural log of a negative number creates a missing value.
gen ln_inctot=ln(inctot)
replace ln_inctot=ln(1) if ln_inctot==. /* missings now ln(1)=0 */
gen yr=year-1900
replace yr=yr-100 if yr >= 100 /* 0,1,etc instead of 100,101 for 2000 onwards */
order yr year



** "label": This command let you put labels on datasets, variables or values 
**  this helps to make it clear exactly what the dataset contains.
label data "Data from CPS 2014-2015"
label variable incwage "wage income"

** It can also be helpful to label different values. 
** Imagine countries were coded as numbers (which is the case in many datasets)
** It might be better to label exactly what each value represents. 
** This is achieved by first defining a label (giving it a name and specifying the mapping), then associating that label with a variable
tab sex
label define gendercode2 1 "Male" 2 "Female"
label values sex gendercode2
tab sex
codebook sex



** "rename": this command can change the names of your variables
rename sex gender
rename gender sex

** "recode": this command can change the values that certain variables take
** This command can also be used to recode missing values to the dot that Stata uses to denote missing
** And you can recode several variables at once
recode sex (1=0) (2=1)
recode incwage inctot (0 = .)

** "recode" can not only several variables but several changes at the same time. 
** We could for example use recode to generate a new variable with categorical population values
recode incwage (0 / 50000 = 1) (50001 / 100000 = 2) (100000 / 7000000 = 3)

** Stata stores or formats data in either of two ways – numeric or string.
** Numeric will store numbers while string will store text (it can also be used to store numbers, but you will not be able to perform numerical analysis on those numbers).

** tostring: change variable to string
tostring year, replace

** destring: change variable to numeric
destring year, gen(year1)


** decode
decode statefip,gen(state_name)
order statefip state_name

** encode
encode state_name, gen(state_id)
order state_name state_id


** Combining and dividing variables
tostring year1, gen(yearcode)
gen yearcode1 = string(year1)
gen stateyear = state_name + yearcode1
order yearcode1 state_name stateyear


gen yr2 = substr(yearcode,3,2)
gen yr1 = substr(yearcode,-2,2)
order yr2 yr1 yearcode


gen stateyear1 = state_name + " " + yearcode1
gen state_name1=substr(stateyear1,1,strpos(stateyear1," ")-1)
gen yearcode2=trim(substr(stateyear1, strpos(stateyear1," "),11))
gen state_name2=trim(substr(stateyear1, 1, strpos(stateyear1," ")))


** Create dummy variables: method 1
gen largewage1=(incwage>=30000)
order largewage1 incwage



** Create dummy variables: method 2
tab statefip, gen(state_d)
order statefip state_d1-state_d23

** Create dummy variables: method 3
destring year, replace

reg incwage i.sex i.year  
reg incwage i.sex#i.year  
reg incwage i.sex##i.year
