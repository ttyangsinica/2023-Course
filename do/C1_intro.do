** Use do-files and log-files to keeping track of things that you did
** The results of each command can be recorded in a log-file for review when the do-file is finished running.
** "clear": cleam up any previous data, otherwise you can not load new dataset 
clear

set more off

** It is good practice to keep extensive notes within your do-file 
** Thus, when you look back over it you know what you were trying to achieve with each command or set of commands
** You can insert comments in several different ways


** Method 1  //
** Stata will ignore a line if it starts with two consecutive slashes (or with an asterisk *).
use "$rawdata\acs_2015.dta", replace // open data


** Method 2 /* */
** You can place notes after a command by inserting it inside these pseudo-parentheses
use "$rawdata\acs_2015.dta", replace /* open data */

/*
use "$rawdata\acs_2015.dta", replace 
use "$rawdata\acs_2015.dta", replace 

*/


** Method 3  ///
** Lastly you can use three consecutive slashes which will result in the rest of the line being ignored and the next line added at the end of the current line. 
graph twoway (scatter age inctot if year == 2015) /// This combines two scatter plots
(scatter age incwage if year == 2015)

graph twoway (scatter age inctot if year == 2015) 

(scatter age incwage if year == 2015)
