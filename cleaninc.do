* the program replace with missing or zero *(default: missing) if the income
* has got a structural problem i.e. is negative or if in case of the derived
* variables there is an inconsistency with the boolean value.

* to be sure that the program is not loaded in the stata memory
capture program drop cleaninc

program define cleaninc

    syntax varlist [, Myopt *]

    * zero or missing (?)
    scalar value = .

    if "`options'" == "zeros" {
        scalar value = 0
    }

    foreach i of local 0 {

        if strpos("`i'", "di") | strpos("`i'", "pg") | strpos("`i'", "hg") {

            * verify there's the booleanish alter ego of the income variable
            capture confirm variable `i'i

            if !_rc {
                * replace with missing or zero if the boolean is zero and
                * the variable is missing or the boolean is zero and the
                replace `i' = value if (`i'i == 0 & missing(`i')) | `i' < 0
            }

            else {
                * replace with missing or zero if missing or negative
                replace `i' = value if `i' < 0 | missing(`i')
            }

        }

        else {
            di "error: the variable `i' is not an income variable."
        }

    }

end



