clear

/** please change your path
global do = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata"
global workdata = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\workdata"
global pic = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\pic"
*/



// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2021_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\Courses\Causal_Inference_Big_Data\Slides\STATA\C6_graphs"
*/



capture log close
log using "$log\C6_graphs", replace text
set more off

use "$rawdata\cps_2014_16.dta",replace

** Histogram

//keep if year==2015
sum inctot,d
hist ftotval if ftotval< 60000 & ftotval>0, bin(100) percent 
graph export "$pic\C6_f1.png", replace width(3000)

hist ftotval if ftotval< 60000 & ftotval>0, bin(100) percent normal
graph export "$pic\C6_f2.png", replace width(3000)


hist ftotval if ftotval< 60000 & ftotval>0, bin(100) percent title(TITLE) subtitle(insert subtitle of graph) /// 
note(insert note to appear at bottom of graph) caption(insert caption to appear below notes)
graph export "$pic\C6_f3.png", replace width(3000)



hist ftotval if ftotval< 60000 & ftotval>0, bin(100) percent title(Family Income Distribution) subtitle(2015) /// 
note(Source: CPS) 
graph export "$pic\C6_f3_ex.png", replace width(3000)




hist ftotval if ftotval< 60000 & ftotval>0, bin(100) percent title(Family Income Distribution) subtitle(2015) /// 
xtitle(insert x axis name) ytitle(insert y axis name)
graph export "$pic\C6_f4.png", replace width(3000)



hist ftotval if ftotval< 60000 & ftotval>0, bin(100) percent normal title(Family Income Distribution) subtitle(2015) /// 
xtitle(family income) ytitle(insert y axis name) xlabel(0(10000)60000) ylabel(0(0.5)3)
graph export "$pic\C6_f5.png", replace width(3000)

hist sex, discrete percent title(gender) subtitle(2015) xtitle(gender) ytitle(percent) xlabel(1 "male" 2 "female")
graph export "$pic\C6_f6.png", replace width(3000)

** kdensity

kdensity ftotval if ftotval< 60000 & ftotval>10000, bwidth(3)
graph export "$pic\C6_f7.png", replace width(3000)

kdensity ftotval if ftotval< 60000 & ftotval>10000, bwidth(3) normal
graph export "$pic\C6_f8.png", replace width(3000)



** twoway scatter
//use $rawdata\fertility_setting.dta,replace

use $rawdata\pwt90.dta,replace

keep if year==2010
gen gdp_per = rgdpo/pop
label variable gdp_per "GDP per capita"
drop if gdp_per >50000

graph twoway scatter hc gdp_per
graph export "$pic\C6_f14.png", replace width(3000)

graph twoway (scatter hc gdp_per) (lfit hc gdp_per)
graph export "$pic\C6_f14_1.png", replace width(3000)

graph twoway (scatter hc gdp_per) (lfitci hc gdp_per)
graph export "$pic\C6_f14_2.png", replace width(3000)

graph twoway (lfitci hc gdp_per) (scatter hc gdp_per) 
graph export "$pic\C6_f14_2.png", replace width(3000)

use $rawdata\pwt90.dta,replace

keep if year==2010
gen gdp_per = rgdpo/pop
label variable gdp_per "GDP per capita"
keep if gdp_per <50000  & gdp_per >30000

graph twoway (lfitci hc gdp_per) (scatter hc gdp_per, mlabel(countrycode) ) 
graph export "$pic\C6_f14_3.png", replace width(3000)


graph twoway (lfitci hc gdp_per) ///
(scatter hc gdp_per, mlabel(countrycode)) ///
, title("GDP per capita and Human Development Index") ///
ytitle("Human Development Index") ///
legend(ring(0) order(2 "linear fit" 1 "95% CI")) 
graph export "$pic\C6_f14_4.png", replace width(3000)


/*
graph twoway scatter change setting 
graph export "$pic\C6_f14.png", replace width(3000)


graph twoway (scatter setting effort) (lfit setting effort)
graph export "$pic\C6_f14_1.png", replace width(3000)

graph twoway (scatter setting effort) (lfitci setting effort)
graph export "$pic\C6_f14_2.png", replace width(3000)

graph twoway (lfitci setting effort) (scatter setting effort) 
graph export "$pic\C6_f14_2.png", replace width(3000)

graph twoway (lfitci change setting) (scatter change setting, mlabel(country) ) 
graph export "$pic\C6_f14_3.png", replace width(3000)


graph twoway (lfitci change setting) ///
(scatter change setting, mlabel(country)) ///
, title("Fertility Decline by Social Setting") ///
ytitle("Fertility Decline") ///
legend(ring(0) order(2 "linear fit" 1 "95% CI")) 
graph export "$pic\C6_f14_4.png", replace width(3000)
*/

** Line graph
sysuse uslifeexp, clear

graph twoway (line le_wmale le_bmale year , clcolor(blue red) ) ///
        , title("U.S. Life Expectancy") subtitle("Males") ///
        legend( order(1 "white" 2 "black") ring(0) pos(5)) ///
		graph export "$pic\C6_f14_5.png", replace width(3000)

graph twoway (line le_wmale le_bmale year , clcolor(blue red) ) ///
        , title("U.S. Life Expectancy") subtitle("Males") ///
        legend( order(1 "white" 2 "black") ring(0) pos(5)) ///
		yscale(log range(25 80))
		graph export "$pic\C6_f14_5.png", replace width(3000)

graph display, scheme(economist)
graph export "$pic\C6_f14_6.png", replace width(3000)

		

** more graph commands
graph twoway connected mpg price, sort(price)
graph export "$pic\C6_f16.png", replace width(3000)

graph twoway area mpg price, sort(price)
graph export "$pic\C6_f17.png", replace width(3000)

graph twoway dropline mpg price in 1/5
graph export "$pic\C6_f18.png", replace width(3000)

** graph bar

graph bar (count), over(sex)
graph export "$pic\C6_f9.png", replace width(3000)

graph bar (percent), over(sex) over(year)
graph export "$pic\C6_f10.png", replace width(3000)


graph hbar (percent), over(sex) over(year)
graph export "$pic\C6_f10_h.png", replace width(3000)

replace ftotval = ftotval/1000
graph bar (mean) ftotval, over(sex) by(year)
graph export "$pic\C6_f11.png", replace width(3000)

** graph hbox
graph box ftotval if ftotval< 60000 & ftotval>10000, over(sex)
graph export "$pic\C6_f12.png", replace width(3000)



** Customizing Appearance
use "$rawdata\ind_gdp_wage.dta",replace

cd "$pic"
**  real GDP per hour (labor productivity) v.s. real wage in Taiwan
graph twoway (connected  rgdp_hour_cg81  year if ind_code =="IND_SER", msymbol(O) mcolor(blue)) (connected c_paid_w_hour_cg81   year if ind_code =="IND_SER",msymbol(T) mcolor(red)),  legend(position(10) ring(0) col(1)  label(1 "real GDP per hour (labor productivity) ") label(2 "real wage")  ) xtitle(year) ytitle(accumulated growth rate(%),angle(vertical)) xlabel(1981(4)2014,grid) ylabel(0(100)400,angle(hor) labsize(medium))  graphregion(color(white)) legend(on region(lcolor(white))) ytick(#10) xtick(#33)  
graph export f1.png,replace width(3000)






sysuse auto, clear
** graph matrix
graph matrix mpg price weight, half
graph matrix mpg price weight
graph export "$pic\C6_f13.png", replace width(3000)

** plot placement
graph twoway scatter mpg price, by(foreign, norescale)
graph export "$pic\C6_f19.png", replace width(3000)

graph twoway scatter mpg price if mpg>10 || scatter mpg price if price>5000
graph export "$pic\C6_f20.png", replace width(3000)


** fitting results
graph twoway lfitci mpg weight || scatter mpg weight
graph export "$pic\C6_f21.png", replace width(3000)


graph twoway qfitci mpg weight || scatter mpg weight
graph export "$pic\C6_f22.png", replace width(3000)
