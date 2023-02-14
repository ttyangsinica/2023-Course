clear

** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\Courses\Causal_Inference_Big_Data\Slides\L7_RDD"
*/


/** please change your path
global do = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\pic"
*/

capture log close
log using "$log\RDD-LMB-data", replace text
set more off

use "$rawdata\RDD-LMB-data.dta", clear

** install useful ado
** useful website: https://sites.google.com/site/rdpackages/home

ssc install binscatter, replace


ssc install cmogram, replace
ssc install rd, replace
ssc install rdrobust, replace
findit rdrobust
net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace

net install lpdensity, from(https://raw.githubusercontent.com/nppackages/lpdensity/master/stata) replace


//net install rdrobust, from(https://sites.google.com/site/rdpackages/rdrobust/stata) replace
//net install rddensity, from(https://sites.google.com/site/rdpackages/rddensity/stata) replace

** Please see below
//ssc install DCdensity,replace
//findit DCdensity

/*
You will also need to install McCrary's DCdensity.ado package and unfortunately 
you can't use the "ssc install" or "net install" commands to do so.  So, here 
are your instructions.  Here are the instructions: 

http://eml.berkeley.edu/~jmccrary/DCdensity/README

1. First download the ado file from McCrary's website. Pay attention to where it downloads
as we are going to be moving it.

http://emlab.berkeley.edu/~jmccrary/DCdensity/DCdensity.ado

2.  Next, put the DCdensity.ado file in your ado folder.  If you don't know where your ado 
folder is, issue -sysdir- from the STATA prompt and it will tell you.  Mine is:

. sysdir
   STATA:  /Applications/Stata/
    BASE:  /Applications/Stata/ado/base/
    SITE:  /Applications/Stata/ado/site/
    PLUS:  ~/Library/Application Support/Stata/ado/plus/
PERSONAL:  ~/Library/Application Support/Stata/ado/personal/
OLDPLACE:  ~/ado/

So I will be moving the .ado package to /Library/Application Support/Stata/ado/personal and put
it into the appropriable alphabetized subdirectory (d).  

3.  Note that you will likely have to make your ~/Library folder visible in order 
to do this, which you can do from Terminal by typing "open ~/Library".  

4.  Now move DCdensity.ado into the correct subdirectory.
*/


gen ivy_leg = collegeattend ==2

cd $pic
**** Step 1: Graphical Analysis
//cd D:\nest\Dropbox\causal_data_working\L7_RDD
** graph rawdata 
scatter score demvoteshare, msize(small) xline(0.5) xtitle("Democrat vote share") ytitle("ADA score")
graph export f1.png, replace

** graph aggregated data using "binscatter"
binscatter score demvoteshare if demvoteshare>=0.2 & demvoteshare<=0.8, n(100) rd(0.5) linetype(qfit)
graph export f2.png, replace

** show there is NO discontinuity in other covariates 
binscatter ivy_leg demvoteshare if demvoteshare>=0.2 & demvoteshare<=0.8, n(100) rd(0.5) linetype(qfit)
graph export f3.png, replace

binscatter pres_dem_pct demvoteshare if demvoteshare>=0.2 & demvoteshare<=0.8, n(100) rd(0.5) linetype(qfit)
graph export f4.png, replace

binscatter pcthighschl demvoteshare if demvoteshare>=0.2 & demvoteshare<=0.8, n(100) rd(0.5) linetype(qfit)
graph export f5.png, replace

binscatter pctblack demvoteshare if demvoteshare>=0.2 & demvoteshare<=0.8, n(100) rd(0.5) linetype(qfit)
graph export f6.png, replace

reg score ivy_leg pcthighschl pctblack sex age i.militaryservice
predict score_hat

binscatter score_hat demvoteshare if demvoteshare>=0.2 & demvoteshare<=0.8, n(100) rd(0.5)


** Step 2: test sorting behavior
/*
capture drop X2 Y2 r2 fhat2 se_fhat2
DCdensity demvoteshare if demvoteshare >=0.2 & demvoteshare<=0.8 , breakpoint(0.5) gen(X2 Y2 r2 fhat2 se_fhat2) graphname(f7.png)
*/

rddensity demvoteshare, c(0.5) all plot 
graph export f7.png, replace




**** Step 3: Preparation for Estimation
drop democrat

** Generate treatment variable
gen democrat = demvoteshare>=0.5

* Generate some Polynomials (recenter to cutoff 0.5)
gen x_c = demvoteshare - 0.5
gen x2_c = x_c^2
gen x3_c = x_c^3
gen x4_c = x_c^4
gen x5_c = x_c^5

* Generate some Polynomials (recenter to cutoff 0.5) interacted with treatment variable
gen d_x_c = democrat*x_c 
gen d_x2_c = democrat*x2_c 
gen d_x3_c = democrat*x3_c 
gen d_x4_c = democrat*x4_c 
gen d_x5_c = democrat*x5_c 



**** Step 4: Implement Estimation

*** 4.1 Parametric Approach
* Use all obs and flexible functional form
reg score democrat x_c-x5_c d_x_c-d_x5_c
reg score i.democrat##(c.x_c c.x2_c c.x3_c c.x4_c c.x5_c)

* Use all obs and SEs with clustering   
reg score democrat x_c-x5_c d_x_c-d_x5_c,cl(id2)
reg score i.democrat##(c.x_c c.x2_c c.x3_c c.x4_c c.x5_c),cl(id2)

*** 4.2 Nonparametric Approach (local linear regression)

* local linear regression with 0.1 bandwidth
reg score democrat x_c d_x_c if (demvoteshare>.45 & demvoteshare<.55)
reg score i.democrat##(c.x_c) if (demvoteshare>.45 & demvoteshare<.55)

* Better SEs with clustering
reg score democrat x_c d_x_c if (demvoteshare>.45 & demvoteshare<.55),cl(id2)
reg score i.democrat##(c.x_c) if (demvoteshare>.45 & demvoteshare<.55),cl(id2)

* use "rdrobust"
** install it
findit rdrobust

rdrobust score demvoteshare, c(0.5) h(0.05)

** different optimal bandwidth selector
rdrobust score demvoteshare, c(0.5) bwselect(msetwo)
rdrobust score demvoteshare, c(0.5) all bwselect(msesum)

 
 
log close
