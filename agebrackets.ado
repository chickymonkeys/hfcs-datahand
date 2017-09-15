********************************************************************************
* This is a simple program to generate age brackets grouping the household     *
* reference person's age in ten-years cohorts.                                 *
* To do so, we follow the codes in the second wave codebook of the HFCS.       *
*                                                                              *
* output is a variable ageRange which contains the age cohorts values.         *
*                                                                              *
* ECB - v 1.0 2017/08/04 - Alessandro Pizzigolotto                             *
*                                                                              *
********************************************************************************

* to be sure that the program is not loaded in the stata memory
* capture program drop agebrackets

*! agebrackets v1.0.1 APizzigolotto 04aug2017
program define agebrackets

  syntax varlist

  capture confirm variable ageRange

  if !_rc {
    di "The age brackets were already determined. Overwrite."
    * exit _rc works as a break inside the condition
    capture novarabbrev drop ageRange
  }

  * if age < 16 or missing we don't count it.
  gen ageRange = .

  * age variable (canberra or not)
  if "`varlist'" == "dhageh" | "`varlist'" == "dhageh1" | "`varlist'" == "dhageh2" | "`varlist'" == "dhageh3" | "`varlist'" == "ra0300" {
    replace ageRange = 1 if `varlist' > 15 & `varlist' < 35
    replace ageRange = 2 if `varlist' > 34 & `varlist' < 45
    replace ageRange = 3 if `varlist' > 44 & `varlist' < 55
    replace ageRange = 4 if `varlist' > 54 & `varlist' < 65
    replace ageRange = 5 if `varlist' > 64 & `varlist' < 75
    replace ageRange = 6 if `varlist' > 74
  }

  * if we pass a pre-compiled age brackets variable (canberra or not)
  else if "`varlist'" == "dhagehb" | "`varlist'" == "dhageh1b" | "`varlist'" == "dhageh2b" | "`varlist'" == "dhageh3b"  {
    replace ageRange = 1 if `varlist' == 16 | `varlist' == 20 | `varlist' == 25 | `varlist' == 30
    replace ageRange = 2 if `varlist' == 35 | `varlist' == 40
    replace ageRange = 3 if `varlist' == 45 | `varlist' == 50
    replace ageRange = 4 if `varlist' == 55 | `varlist' == 60
    replace ageRange = 5 if `varlist' == 65 | `varlist' == 70
    replace ageRange = 6 if `varlist' == 75 | `varlist' == 80 | `varlist' == 85
  }

  else {
    di "error: age variable not found. no variable created."
  }

  capture label drop ageRange_`varlist'
  label define ageRange_`varlist' 1 "16-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75+"
  label values ageRange ageRange_`varlist'

end
