* More or less
	* Purpose: Generate an indicator for whether variable of interest is higher or lower than median.
	* Usage: 				more_or_less varname, generate(newvar) [options]
	*        				by groupvars: 	more_or_less varname, generate(newvar) [options]
	cap program drop 	more_or_less
	program define 		more_or_less, byable(recall)

		syntax varlist(max=1) , [GENerate(name)] [includemedian] [prefix(string)] [VARLABel(string asis)] [VALLABel(string asis)] [invert]
		
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
			
		* Determine new variable name
		if "`prefix'" != "" {
			local prefix "`prefix'_"
			local prefix = subinstr("`prefix'","__","_",.)
			local newvar `prefix'`varname'
		}
		else {
			local newvar `generate'
		}
		
		
		* Create variable if this is the first by-group or no by-groups
		if _byindex() == 1 {
			cap drop `newvar'
			gen `newvar' = .
		}
		
		* Mark sample for current by-group
		marksample touse
		
		* Calculate median and create binary indicator for current by-group
		qui count if !mi(`varname') & `touse'
		if `r(N)' > 0 {
			qui sum `varname' if `touse', d
			if "`invert'" == "" {
				replace `newvar' = 0 if float(`varname') <= float(`r(p50)') & !mi(`varname') & `touse'
				replace `newvar' = 1 if float(`varname') > float(`r(p50)') & !mi(`varname') & `touse'
			}
			else {
				replace `newvar' = 0 if float(`varname') >= float(`r(p50)') & !mi(`varname') & `touse'
				replace `newvar' = 1 if float(`varname') < float(`r(p50)') & !mi(`varname') & `touse'
			}
			if "`includemedian'" != "" replace `newvar' = 1 if float(`varname') == float(`r(p50)') & !mi(`varname') & `touse'
		}
		
		
		* Add Labels (only on first by-group to avoid repeated labeling)
		if _byindex() == 1 {
			if `"`varlabel'"' != "" lab var `newvar' `varlabel'
			
			if `"`vallabel'"' != "" {
				lab define `newvar' `vallabel' , replace
				lab val `newvar' `newvar'
			}
		}
	end