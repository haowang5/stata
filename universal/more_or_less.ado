
	* More or less
	* Purpose: Gnerate an indicator for whether variable of interest is higher or lower than median.
	program define 		more_or_less
	
		syntax varlist(max=1) , [GENerate(name)] [prefix(string)] [bin(varlist)] [includemedian] [VARLABel(string asis)] [VALLABel(string asis)]
		
		local varname : word 1 of `varlist'
		
		* Check Assumptions
		if "`generate'" != "" & "`prefix'" != "" {
				di as err "{p}options generate and prefix mutually exclusive{p_end}"
				exit 198
			}
			
			
		if "`generate'" == "" & "`prefix'" == "" {
				di as err "{p}must select one of options generate and prefix{p_end}"
				exit 198
		}
			
			
		* Gnerate Empty New Var with Specified Name
		if "`prefix'" != "" {
			local prefix "`prefix'_"
			local prefix = subinstr("`prefix'","__","_",.)
		}
			
			
		if "`generate'" != ""{
			cap drop `generate'
			gen `generate' = .
			local newvar  `generate'
		}
		else {
			cap drop `prefix'`varname'
			gen `prefix'`varname' = .
			local newvar `prefix'`varname'
		}
		
		
		* Replace New Var with Values (by Bin if Specified)
		local missing_bin_values ""
		if "`bin'" != "" {
			egen more_or_less_group = group(`bin')
			qui levelsof more_or_less_group
			foreach i in `r(levels)' {
			
				qui sum `varname' if more_or_less_group == `i' , d
				if `r(N)' != 0 {
					replace `newvar' = 0 if float(`varname') <= float(`r(p50)') 	& !mi(`varname') & more_or_less_group == `i'
					replace `newvar' = 1 if float(`varname') > float(`r(p50)')		& !mi(`varname') & more_or_less_group == `i'
					if "`includemedian'" != "" replace `newvar' = 1 if float(`varname') == float(`r(p50)') 	& !mi(`varname') & more_or_less_group == `i'
				}
				else {
					* Check if this bin has observations but all are missing
					qui count if more_or_less_group == `i'
					if `r(N)' > 0 {
						* Get the actual bin variable values for this group
						qui levelsof `bin' if more_or_less_group == `i', local(bin_vals) clean
						local missing_bin_values "`missing_bin_values' (`bin_vals')"
					}
				}
			}
			drop more_or_less_group
		}
		else {
			qui sum `varname' , d
			replace `newvar' = 0 if float(`varname') <= float(`r(p50)') 	& !mi(`varname')
			replace `newvar' = 1 if float(`varname') > float(`r(p50)')		& !mi(`varname')
			if "`includemedian'" != "" replace `newvar' = 1 if float(`varname') == float(`r(p50)') 	& !mi(`varname')
		}
		
		
		* Add Label
		if `"`varlabel'"' != "" lab var `newvar' `varlabel'
		
		if `"`vallabel'"' != "" {
			lab define `newvar' `vallabel' , replace
			lab val `newvar' `newvar'
			
		}
		
		* Print formatted warning for bins with all missing data
		if "`missing_bin_values'" != "" {
			di as txt ""
			di as txt "{hline 60}"
			di as txt "WARNING: Bins with all missing values detected"
			di as txt "{hline 60}"
			di as txt "Variable: {bf:`varname'}"
			di as txt "Bin variable(s): {bf:`bin'}"
			di as txt "Bins with all missing values: {bf:`missing_bin_values'}"
			di as txt "{hline 60}"
			di as txt ""
		}

	end
