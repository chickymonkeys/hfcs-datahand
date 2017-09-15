********************************************************************************
* This is a simple program to generate age brackets grouping the household     *
* reference person's age in ten-years cohorts.                                 *
* To do so, we follow the codes in the second wave codebook of the HFCS.       *
*                                                                              *
* output is a variable educLevel which contains the education cohorts values.  *
*                                                                              *
* ECB - v 1.0 2017/08/04 - Alessandro Pizzigolotto                             *
*                                                                              *
********************************************************************************

*capture program drop educbrackets

*! educbrackets v1.0.1 APizzigolotto 04aug2017
program define educbrackets

    * educbrackets <varname> [, noeduc]
    syntax varlist [, MYopt *]

    capture confirm variable educLevel

    if !_rc {
        di "The education level brackets were already determined. Overwrite."
        * exit _rc works as a break inside the condition
        capture novarabbrev drop educLevel
    }

    * initialize the categorical variable
    generate educLevel = .

    * pa0200 is at individual level, the others are derived from the
    * individual level for the main households
    if "`varlist'" == "dheduh" | "`varlist'" == "dheduh1" | "`varlist'" == "dheduh2" | "`varlist'" == "dheduh3" | "`varlist'" == "pa0200" {
        * with the option "noeduc" we distinguish in two groups with a dummy variable
        * people with basic or no education and people educated
        if "`options'" == "noeduc" {
            replace educLevel = 0 if `varlist' >= 0 & `varlist' < 3
            replace educLevel = 1 if `varlist' >  2 & !missing(`varlist')
            * labeling the dummy variable
            capture label drop educLevel_`varlist'
            label define educLevel_`varlist' 0 "Basic or No Education" 1 "Secondary or Tertiary Education"
        }
        else {
            * we assign the value one it there's eduation from zero to middle school
            replace educLevel = 1 if `varlist' >= 0 & `varlist' < 3
            replace educLevel = 2 if `varlist' >  2 & `varlist' < 5
            replace educLevel = 3 if `varlist' >  4 & !missing(`varlist')
            * labeling the categories
            capture label drop educLevel_`varlist'
            label define educLevel_`varlist' 1 "Basic Education" 2 "Secondary" 3 "Tertiary"
        }

        label values educLevel educLevel_`varlist'
    }

    else {
        di "error: educational attainment variable not found. no variable created."
    }

end
