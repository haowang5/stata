
	* Purpose: Clean string variable. Remove extra spaces, convert to ASCII characters if specified, apply capitalization option as specified, apply Regex if specified.
	* Author: HW
	* Date Written: Jul 2024
	* Last Edited: Sep 4 2024
	program define strclean 
		version 14
		syntax varlist [, upper lower proper ascii suffix(string) Generate(namelist) replace KEEPChar(string) KEEPPattern(string) notrim]
		
		local all_three = 0
		foreach op in `upper' `lower' `proper' {
			if `"`op'"'!= "" local all_three = `all_three' + 1
		}
		if `all_three' == 2 | `all_three' == 3 {
			di as err "{p}options upper, lower and proper mutually exclusive{p_end}"
			exit 198
		}
		
		local all_three = 0
		foreach op in `"`suffix'"' `"`generate'"' `"`replace'"' {
			if `"`op'"'!= "" local all_three = `all_three' + 1
		}
		if `all_three' == 0 {
			di as err "{p}must specify one of suffix, generate and replace {p_end}"
			exit 198
		}
	
		if `all_three' == 2 | `all_three' == 3 {
			di as err "{p}options suffix, generate and replace mutually exclusive{p_end}"
			exit 198
		}	
		
		if "`keepchar'" != "" & "`keeppattern'" != "" {
			di as err "{p}options keepchar and keeppattern mutually exclusive{p_end}"
			exit 198
		} 
		
		local has_suffix `suffix'
		local suffix = subinstr("_`suffix'","__","_",.)
		
		local nvars : word count `varlist'
		if "`generate'" != "" {
			local nname : word count `generate'
			if "`nvars'" != "`nname'" {
				di as err "{p}number of variable names specified in generate() should equal to the number of variables{p_end}"
				exit 198
			}
		}
		
		forval i = 1/`nvars' {
			local var : word `i' of `varlist'
			tempvar to_be_cleaned
			gen `to_be_cleaned' = `var'
			count if !mi(`to_be_cleaned')
			if "`ascii'" != "" replace `to_be_cleaned' = ustrto(ustrnormalize(`to_be_cleaned', "nfd"), "ascii", 2)
			local hastrim 1
			if "`notrim'" != "" local hastrim 0
			if `hastrim' == 1 replace `to_be_cleaned' = stritrim(`to_be_cleaned')
			if `hastrim' == 1 replace `to_be_cleaned' = ustrtrim(`to_be_cleaned')
			count if !mi(`to_be_cleaned')
			if "`proper'" != "" {
				replace `to_be_cleaned' = strproper(`to_be_cleaned')
			}
			if "`upper'" != "" {
				replace `to_be_cleaned' = ustrupper(`to_be_cleaned')
			}
			if "`lower'" != "" {
				replace `to_be_cleaned' = ustrlower(`to_be_cleaned')
			}
			
			if `"`keepchar'"' != "" {
				replace `to_be_cleaned' = ustrregexra(`to_be_cleaned', `"[^`keepchar']"', "")
			}
			
			if `"`keeppattern'"' != "" {
				gen `to_be_cleaned'p = regexs(1) if regexm(`to_be_cleaned', `"`keeppattern'"')
				replace `to_be_cleaned' = `to_be_cleaned'p
				drop `to_be_cleaned'p
			}
			
			if "`has_suffix'" != "" {
				gen `var'`suffix' = `to_be_cleaned'
				order `var'`suffix' , after(`var')
			}
			
			if "`generate'" != "" 	{
				local genvarname `: word `i' of `generate''
				gen `genvarname' = `to_be_cleaned'
				order `genvarname' , after(`var')
			}
			if "`replace'" != "" replace `var' = `to_be_cleaned'
		}
		
	end
