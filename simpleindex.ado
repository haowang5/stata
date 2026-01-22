	* Purpose: Create a standarized index
	* Options: 
		* varlist: index components
		* flip: flip the variable to get the desired direction 
		* normby: pass the indicator for control group if you want to standarize by the mean and sd of control group
		* generate: varname of the generated index
	* Sample Usage: 
	* 	simpleindex var1 var2 var3 , gen(sample_index) fl(var3) normby(control) varlab("Sample Index")
	* 	bys survey_round : simpleindex var1 var2 var3 , gen(sample_index) fl(var3) normby(control) varlab("Sample Index")
	* Author: HW
	* Date Written: Jul 2024
	* Last Edited: July 3 2025
	program define simpleindex, byable(recall)
	
		syntax varlist , GENerate(name) [FLip(varlist) normby(varname) VARLABel(string asis)]
	
		* Create variable if this is the first by-group or no by-groups
		if _byindex() == 1 {
			cap drop `generate'
			gen double `generate' = .
		}

		* Mark sample for current by-group
		marksample touse
		
		* Check if all the components are missing for all observations in the subsample
		* If all missing, create an index with (.) for this subsample
		mata: st_numscalar("allmiss", sum(st_data(., tokens("`varlist'"), "`touse'") :!= .)==0)

		* Create the index
		if scalar(allmiss) == 0 {
			local normby_script ""
			if "`normby'" != "" local normby_script  " & `normby' == 1 " 

			foreach i of varlist `varlist' {
				qui sum `i' if `touse' `normby_script'
				gen `i'_z = (`i'-`r(mean)')/`r(sd)' if `touse'
			}

			if "`flip'" != "" {
				foreach i of varlist `flip' {
					replace `i'_z = -`i'_z if `touse'
				}
			}

			egen `generate'_t = rowmean(*_z) if `touse'
			qui sum `generate'_t if `touse' `normby_script'
			replace `generate' = (`generate'_t - `r(mean)')/`r(sd)' if `touse'

			drop `generate'_t *_z
		}
		else {
			replace `generate' = . if `touse'
			di "Skipped All"
		}

		* Add Labels (only on first by-group to avoid repeated labeling)
		if _byindex() == 1 {
			if `"`varlabel'"' != "" lab var `generate' `varlabel'
		}
	
	end