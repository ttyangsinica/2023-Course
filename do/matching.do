clear

** please change your path
global rawdata="C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"

*/



ssc install psmatch2

use $rawdata\lalonde.dta,replace

gen id=_n

** Step 1: Test Differences in Outcomes in Pre-matching Data
ttest re78, by(treat)
reg re78 treat,r

** Step 2: Test Differences in Covariates in Pre-matching Data
ttest age, by(treat)
ttest educ, by(treat)
reg age treat,r
reg educ treat,r

** Step 3: PSM Estimation -- teffects psmatch
teffects psmatch (re78) (treat age educ  black  hispan  nodegree  married  re74  re75, logit), nn(1) ate
teffects psmatch (re78) (treat age educ  black  hispan  nodegree  married  re74  re75, logit), nn(1) atet
teffects psmatch (re78) (treat age educ  black  hispan  nodegree  married  re74  re75), nn(1)  atet gen(matchnum)

** for understanding matching process
predict ps1, ps
predict y0 y1, po
predict te

order id matchnum1 treat re78 ps1 y0 y1 te

keep if id==1 | id==254

order treat id matchnum1 ps1 y0 y1 te

** Step 4: Post Matching Analysis -- teffects psmatch
teffects psmatch (re78) (treat age educ  black  hispan  nodegree  married  re74  re75), nn(1)  atet 

tebalance box re74
graph export "$pic\b-plot.png", replace width(3000)

tebalance density educ
graph export "$pic\b-dens.png", replace width(3000)

tebalance density
graph export "$pic\ps-dens.png", replace width(3000)

tebalance summarize


** Step 3: PSM Estimation -- psmatch2
psmatch2 treat age educ  black  hispan  nodegree  married  re74  re75, out(re78) logit n(1)
psmatch2 treat age educ  black  hispan  nodegree  married  re74  re75, out(re78) logit n(1) noreplace

** Step 4: Post Matching Analysis -- psmatch2
pstest age educ  black  hispan  nodegree  married  re74  re75
pstest age educ  black  hispan  nodegree  married  re74  re75, both
pstest educ, box both
graph export "$pic\ps_edu.png", replace width(3000)

pstest _pscore, density both
graph export "$pic\ps_score.png", replace width(3000)


/** weighting approach
logit treat age educ  black  hispan  nodegree  married  re74  re75
predict ps 

gen w_ate = treat/ps+ (1-treat)/(1-ps)
gen w_att = treat + (1-treat)*(ps/(1-ps))


reg re78 treat age educ  black  hispan  nodegree  married  re74  re75 [aw=w_ate],r
reg re78 treat age educ  black  hispan  nodegree  married  re74  re75 [aw=w_att],r

