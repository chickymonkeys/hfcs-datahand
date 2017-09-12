********************************************************************************
* Version: 1.0.0                                                               *
* Title: encodestrings                                                         *
* Author: Alessandro Pizzigolotto (gitlab: @dubidub)                           *
* this subroutine is used to encode string variables as numeric, saving the    *
* strings in the label, e.g. to ensure that sa0100 is treated as numeric in a  *
* standard way, no matter the HFCS dataset we are working at.                  *
* in this way, we can refer at countries as "country_code":country to deal     *
* with countries' exceptions in the code                                       *
********************************************************************************

*! setenv v1.0.1 APizzigolotto 11sep2017
program encodestrings

    * define syntax command of encodestrings
    syntax varlist

    foreach var of varlist `varlist' {

        * exception for sa0100: if it is numeric, decode it using the value of
        * the label (which there should be from the initial dataset) in order to
        * avoid id mismatching during the analysis
        if "`var'" == "sa0100" {
            * check if sa0100 is numeric, if it is _rc == 0, then decode it
            * into string and order it alphabetically
            capture confirm numeric variable `var'
            if !_rc {
                * if numeric, decode it using the label which contains
                * the country codes
                decode `var', gen(`var'_string)
                drop `var'
                rename `var'_string `var'
                * sort the string variable in alphabetical order
                sort `var'
            }
        }


        * capture suppresses the output of the command and returns zero if it's
        * all good, while confirm verifies the variable type
        capture confirm numeric variable `var'

        if _rc {
            * give specific name to the label for country code
            local varname = "`var'_string"

            * unique label name to the country code
            if "`var'" == "sa0100" {

                capture label list country

                if !_rc {

                    * _rc == 0 since country exists
                    scalar breakup = _rc

                    * we want to preserve labels if there are variables which has
                    * a label for its values with the same name
                    unab allvars: *

                    while breakup {
                        local first: word 1 of `allvars'
                        local lbl: value label `first'

                        if "`lbl'" == "country" {
                            capture label copy country countryold
                            capture label values `first' countryold
                            capture label drop country
                            scalar breakup = 1
                        }

                        local allvars: list allvars - first
                        if "`allvars'" == "" {
                            scalar breakup = 1
                        }
                    }
                }

                * if the variable exists but it is not assigned
                capture label drop country
                local varname = "country"
            }

            * precautional sorthing (alphabetical order since it is string)
            sort `var'
            * encode works as egen x = group(y) preparing ids
            encode `var', gen(`varname')
            drop `var'
            rename `varname' `var'
        }
    }

    capture compress

end
