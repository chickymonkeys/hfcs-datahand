********************************************************************************
* This is a simple program to generate age brackets grouping the household     *
* reference person's age in ten-years cohorts.                                 *
* To do so, we follow the codes in the second wave codebook of the HFCS.       *
*                                                                              *
* output is a variable educLevel which contains the education cohorts values.  *
*                                                                              *
* ECB - v 1.0 2017/10/05 - Alessandro Pizzigolotto                             *
*                                                                              *
********************************************************************************

*capture program drop emplbrackets

*! emplbrackets v1.0.1 APizzigolotto 04aug2017
program define emplbrackets

    * emplbrackets <varname>
    syntax varlist

    capture confirm variable emplStatus

    if !_rc {
        di "The employment brackets were already determined. Overwrite."
        * exit _rc works as a break inside the condition
        capture novarabbrev drop emplStatus
    }

    * initialize the categorical variable
    generate emplStatus = .

    * pe0200 is at individual level, the others are derived from the
    * individual level for the main households
    if "`varlist'" == "dhemph" | "`varlist'" == "dhemph1" | "`varlist'" == "dhemph2" | "`varlist'" == "dhemph3" {
        replace emplStatus = 1 if `varlist' == 1
        replace emplStatus = 2 if `varlist' == 3
        replace emplStatus = 3 if `varlist' == 4
        replace emplStatus = 4 if `varlist' == 2 | `varlist' == 5

        * labeling the categories
        capture label drop emplStatus_`varlist'
        label define emplStatus_`varlist' 1 "Employee" 2 "Unemployed" 3 "Retired" 4 "Other not working"

        label values emplStatus emplStatus_`varlist'
    }

    else {
        di "error: employment status variable not found. no variable created."
    }

end
