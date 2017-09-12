use "$WAVE1\D_compl.dta", clear
generate wave = 1
append using "$WAVE2\D_compl.dta"
replace wave = 2 if wave ==.

quietly compress

save "$HFCSDATA\D_compl_w1_w2", replace
