clear

set more off

** You should use a tree-style directory with different folders to organise your work in order to make it easier to find things at a later date

// please change your path
global do = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"
global workdata = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\workdata"
global pic = "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\pic"




** If you changed the directory already, the command can exclude the directory mapping: 
** cd: Sets the default directory where Stata will look for any files you try to open and save any files you try to save
cd $rawdata
cd "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata"


** use full path
use "C:\nest\Dropbox\causal_data_course\2022_spring\Class_Data\rawdata\acs_2015.dta", replace 

** use nickname to represent path
use "$rawdata\acs_2015.dta", replace   


cd $rawdata
use "acs_2015.dta", replace 

** just load few variables
use year datanum serial hhwt region using "$rawdata\acs_2015.dta",replace




** If you do not need all the variables from a data set, you can also load only some of the variables (here: pernum sex age year) from a file


** import a txt (csv) file from outside
import delimited using acs_2015.txt,clear 
import delimited using acs_2015.csv,clear encoding("utf-8")


import delimited ID using acs_2015.csv,clear varnames(1)

import delimited using acs_2015.csv, colrange(1:3) rowrange(3:8) clear

save "$workdata\acs_2015_test1.dta", replace
** Save data: "save"
** replace option: overwrites any previous version of the file in the directory you try saving to 
** If you want to keep an old version as back-up, you should save under a different name


** export delimited using acs_2015.csv, which can be read in excel
** replace option: replace previous version of acs_2015.csv
use "$workdata\acs_2015_test1.dta", replace

export delimited using acs_2015new.csv,replace
export delimited using acs_2015new.txt,replace


** import/export Excel files
export excel using acs_2015new.xlsx, sheet("Data") replace

import excel datanum year serial using acs_2015new.xlsx, sheet("Data") clear 

** "infix": read fixed ASCII format data

** The data cannot be read directly but a codebook is necessary that explains how the data is stored
** To read this type of data into Stata we need to use the infix command and provide Stata with the information from the codebook.

** Since there are a lot of files it my be more convenient to save the codebook information in a separate file, a so called “dictionary file”.
** After setting up this file we would save it as acs_2015.dct
** Since setting up dictionary files is a lot of work, we are lucky that many datasets might already have dictionary files that can be read with STATA 

clear
  infix                ///
  int     year        1-4    ///
  byte    datanum     5-6    ///
  double  serial      7-14   ///
  using `"$rawdata\acs_2015.dat"'


save "$workdata\acs_2015_test2.dta", replace
  

** wrong
clear
quietly infix                ///
  int     year        1-5    ///
  byte    datanum     6-7    ///
  double  serial      8-14   ///
  using `"$rawdata\acs_2015.dat"'  
  
save "$workdata\acs_2015_test3.dta", replace
  

** "compress": to preserve space, only store a variable with the minimum string length necessary
compress


** delete acs_2015_test.dta
erase "$workdata\acs_2015_test1.dta"
erase "$workdata\acs_2015_test2.dta"
erase "$workdata\acs_2015_test3.dta"


/*
** If you are going to make some revisions but are unsure of whether or not you will keep them, then you have two options
** "preserve": this command will take a snapshot of the current dataset
** If you want to revert back to that copy later on, just type "restore"
*/

use "$rawdata\acs_2015.dta", clear  

preserve

gen p=1

restore





