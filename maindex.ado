* Purpose: Create a Michael Anderson (2008) index
	* This program is a wrapper of swindex by Schwab etal
	* Options: 
		* varlist: index components
		* flip: flip the variable to get the desired direction 
		* normby: pass the indicator for control group if you want to standarize by the mean and sd of control group
		* generate: varname of the generated index
	* Sample Usage: 
	* 	maindex var1 var2 var3 , gen(sample_index) fl(var3) normby(control) varlab("Sample Index")
	* 	bys survey_round : maindex var1 var2 var3 , gen(sample_index) fl(var3) normby(control) varlab("Sample Index")
	* Author: HW
	* Date Written: Jul 2024
	* Last Edited: July 3 2025
	program define maindex, byable(recall)
	
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
			local flip_script = ""
			if "`flip'" != "" local flip_script = "flip(`flip')"
			local normby_script = ""
			if "`normby'" != "" local normby_script = "normby(`normby')"

			swindex `varlist' if `touse' , generate(`generate'_r) `flip_script' `normby_script'
			replace `generate' = `generate'_r if `touse'
			drop `generate'_r
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