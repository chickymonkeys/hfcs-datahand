* this subroutine is used to encode string variables as numeric,
* saving the strings in the label, e.g. to ensure that sa0100 is treated
* as numeric instead of str2.

capture program drop encodestrings

* to use this program after the do file use
* encodestrings varlist

program encodestrings
	* define syntax command of encodestrings
	syntax varlist
	foreach var of varlist `varlist' {
		capture confirm numeric variable `var'
		* capture suppresses the output of the command and returns zero if it's
		* all good, while confirm verifies the variable type
		if _rc {
			* give specific name to the label for country code
			local varname = "`var'_string"

			if "`var'" == "sa0100" {
					local varname = "country"
			}

			encode `var', gen(`varname')

      drop `var'

      rename `varname' `var'

		}

  }

end
