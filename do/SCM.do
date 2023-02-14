clear


// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\Courses\Causal_Inference_Big_Data\Slides\L11_Sythetic_control"
*/


cd $workdata

** single treated case
capture log close
log using "$log\sc_method", replace text
set more off

** Step 0: install packages
net from "https://web.stanford.edu/~jhain/Synth"
net install synth, all replace force

//ssc install synth, replace all
net install synth_runner, from(https://raw.github.com/bquistorff/synth_runner/master/) replace
//findit synth_runner

//sysuse smoking
use $rawdata\smoking_ca.dta,replace

** Step 1: Setup Panel Data
tsset state year

** Step 2: SC Estimation
synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989)

** Step 3: SC Graphs
synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) figure 
graph export $pic\PA.png,replace



** Step 4: Other Settings
synth cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) nested allopt counit(4(1)30) keep("sc_results") replace


** Step 5: Statistical Inference
synth_runner cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) pvals1s pre_limit_mult(5) 



clear 
use $rawdata\smoking_ca.dta,replace

** Step 1: Setup Panel Data
tsset state year

** Step 6: Display Effect Graphs (use real file)
synth_runner cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) keep("$rawdata\results") replace
merge 1:1 state year using "$rawdata\results", nogenerate
gen cigsale_synth = cigsale-effect

save $rawdata\scm_results,replace

** Use all untreated units
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)
graph export "$pic/effects.png", as(png) replace

** Use the untreated units whose RMSPE is lower than 5 times of the treated unit's RMSPE
keep if pre_rmspe<=1.943233*5
single_treatment_graphs, trlinediff(-1) effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35)
graph export "$pic/effects_2.png", as(png) replace

** Displays SC estimated treatment effects for treated unit
effect_graphs, trlinediff(-1)

** Step 7: use your own code to draw picture
clear

use $rawdata\smoking_ca.dta,replace

tsset state year


synth_runner cigsale beer(1984(1)1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989)  pvals1s pre_limit_mult(5) keep("$rawdata\results") replace
merge 1:1 state year using "$rawdata\results", nogenerate
gen cigsale_synth = cigsale-effect

save $rawdata\scm_results,replace

keep if pre_rmspe<=1.943233*5

local figure = ""
forv i = 4(1)39{
	local figure = `"`figure' (line effect year if state==`i', mcolor(gs12) lc(gs12) lw(vthin))"'
}
graph twoway `figure' /// 
(line effect year if state==1, mcolor(gs12) lc(gs12) lw(vthin)) (line effect year if state==2, mcolor(gs12) lc(gs12) lw(vthin)) (connect effect year if state==3, mcolor(maroon) lc(maroon)),  leg(order(39 "CA Estimate"  1 "Placebo Estimates") ) ytitle("SCM Estimates") xtitle("Year") 

graph export "$pic/effects_3.png", as(png) replace


** multiple treated case
clear
use $rawdata\smoking_ca.dta,replace
tsset state year

gen byte D = (state==3 & year>=1989) | (state==28 & year>=1988)

synth_runner cigsale beer(1984(1)1987) lnincome(1972(1)1987) retprice age15to24, d(D) //pre_limit_mult(5) //trends training_propr(`=13/18')

effect_graphs //, multi depvar(cigsale)

pval_graphs
