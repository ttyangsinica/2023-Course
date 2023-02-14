
clear

// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"
*/

ssc install pdslasso
ssc install lassopack

use $rawdata\growth.dta,replace


** Control all variables
reg Outcome gdpsh465 bmp1l- tot1,r


** Double Selection Method with LASSO
pdslasso Outcome gdpsh465 (bmp1l- tot1),rob


** step 1 of PDS: 
rlasso Outcome bmp1l- tot1,rob

** step 2 of PDS:  
rlasso gdpsh465 bmp1l- tot1,rob

** step 3 of PDS: 
reg Outcome gdpsh465 bmp1l freetar hm65 sf65 lifee065 humanf65 pop6565,r


/*
cvlasso Outcome gdpsh465 bmp1l- tot1
lasso2 Outcome gdpsh465 bmp1l- tot1,ols long
predict growth1, lambda(0.29996167) xb
*/


/** Select IV examples
** AJR Table 6

use "$rawdata\AJR_table6", clear

//merge 1:1 shortnam using $rawdata\AJR_table8
keep if baseco==1

** original one
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) temp* humid* edes1975 avelf steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock, first

** select covariates
ivlasso logpgp95 (avexpr=logem4) (temp* humid* edes1975 avelf steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock), partial(logem4)

** select IV and covariates
ivlasso logpgp95 (avexpr=logem4 euro1900 - cons00a) (temp* humid* edes1975 avelf steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock), partial(logem4) first


