program define het_table

		// treat_only: when the het variale is available for treatment group only. In this case we compare sub-samples of treatment group with the entire control group
		syntax varlist using/, treat(varname) regcmd(string) hetvar(varname) [breakline(integer 12)] [treat_only]

		* Process using
		* if `using' contains .tex extention, then okay. If not, add .tex to the end. If it has an entention that is not .tex, raise error
		if strpos(`"`using'"', ".tex") == 0 {
			if strpos(`"`using'"', ".") > 0 {
				di as err `"{p}the using file must have .tex extension{p_end}"'
				exit 9
			}
			local using `"`using'.tex"'
		}
		
		* Save temp dataset and restore after running
		tempfile het_table_tempsave
		save `het_table_tempsave', replace
		
		* Keep observations with non-missing hetvar
		keep if !mi(`hetvar')
		
		****
		**## Validate hetvar has exactly 2 levels
		****
		qui levelsof `hetvar'
		if `r(r)' != 2 {
			di as err `"{p}the hetvar variable must have exactly 2 values{p_end}"'
			exit 9
		}
		local hetlevels `r(levels)'
		local level1 : word 1 of `r(levels)'
		local level2 : word 2 of `r(levels)'
		
		* Get value labels for hetvar
		qui elabel list (`hetvar')
		local hetlab_`level1' : word 1 of `r(labels)'
		local hetlab_`level2' : word 2 of `r(labels)'
		
		* Parse regcmd to separate controls and options
		local comma_pos = strpos("`regcmd'", ",")
		if `comma_pos' > 0 {
			local controls = substr("`regcmd'", 1, `comma_pos' - 1)
			local regopts = substr("`regcmd'", `comma_pos', .)
		}
		else {
			local controls "`regcmd'"
			local regopts ""
		}
		
		****
		**## Build table header
		****
		local tabular_columns ""
		local header ""
		local num_outcomes = 1
		
		foreach var of varlist `varlist' {
			* Update tabular columns
			local tabular_columns "`tabular_columns'c"
			local num_outcomes = `num_outcomes' + 1
			
			* Get variable label and format for header
			local curr_varlab "`:variable label `var''"
			local curr_varlab "`=stritrim("`curr_varlab'")'"
			local curr_varlab "`=strtrim("`curr_varlab'")'"
			tokenize "`curr_varlab'"
			
			local current_line ""
			local output_text ""
			
			* Add column name with automatic line breaking
			local p = 1
			while "``p''" != "" {
				local new_token "``p''"
				local new_token_length `=strlen("`new_token'")'
				local current_line_length `=strlen("`current_line'")'
				
				if `= `current_line_length' + `new_token_length' + 1' <= `breakline' {
					if "`current_line'" == "" local current_line "`new_token'"
					else local current_line "`current_line' `new_token'"
				}
				else {
					if "`output_text'" == "" local output_text "`current_line'"
					else local output_text "`output_text' \\ `current_line'"
					local current_line "`new_token'"
				}
				local p = `p' + 1
			}
			if "`output_text'" == "" local output_text "`current_line'"
			else local output_text "`output_text' \\ `current_line'"
			local header "`header' & {\shortstack{`output_text'}}"
		}
		
		****
		**## Panel A: Full sample regression
		****
		eststo clear
		foreach var of varlist `varlist' {
			qui eststo: reg `var' `treat' `controls' `regopts'
			
			* Add statistics
			qui sum `var' if `treat' == 0 & e(sample)
			local c_mean = trim("`: display %9.3f `r(mean)''")
			local c_sd = trim("`: display %9.3f `r(sd)''")
			
			loc treatcoef = _b[`treat']
			capture loc teffect = 100 * (`treatcoef' / `r(mean)')
			if _rc != 0 {
				loc teffect = 0
			}
			local t_effect = trim("`: display %9.3f `teffect''")
			if strpos("`var'", "index") {
				loc t_effect = "-"
			}
			
			* Remove leading zeros
			local c_mean = subinstr(`"`c_mean'"', "0.", ".", .)
			local c_sd = subinstr(`"`c_sd'"', "0.", ".", .)
			local t_effect = subinstr(`"`t_effect'"', "0.", ".", .)
			
			estadd local c_mean `c_mean'
			estadd local c_sd `c_sd'
			estadd local t_effect `t_effect'
		}
		
		* Export Panel A
		esttab using `"`using'"', replace ///
			prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l`tabular_columns'} \toprule") ///
			posthead("`header' \\ \midrule \multicolumn{`num_outcomes'}{c}{\textbf{\textit{Panel A — Pooled}}} \\ ") ///
			prefoot("[1ex]") nogaps nocons nolz label cells(b(fmt(a3) star) se(par fmt(a3)) p(par([ ]) fmt(a3))) ///
			fragment booktabs compress collabels(none) nomtitles keep(`treat') ///
			stats(c_mean c_sd t_effect N, labels("Control Mean" "Control SD" "Treatment Effect (\%)" "N")) ///
			star(* 0.10 ** 0.05 *** 0.01) nobase noomitted
		eststo clear
		
		****
		**## Panel B & C: Regressions by hetvar levels
		****
		local panelnum 66
		foreach hetval in `hetlevels' {
			eststo clear
			
			foreach var of varlist `varlist' {
				if "`treat_only'" == "" {
					qui eststo: reg `var' `treat' `controls' if `hetvar' == `hetval' `regopts'
				}
				else {
					qui eststo: reg `var' `treat' `controls' if `hetvar' == `hetval' | `treat' == 0 `regopts'
				}
				
				* Add statistics
				qui sum `var' if `treat' == 0 & e(sample)
				local c_mean = trim("`: display %9.3f `r(mean)''")
				local c_sd = trim("`: display %9.3f `r(sd)''")
				
				loc treatcoef = _b[`treat']
				capture loc teffect = 100 * (`treatcoef' / `r(mean)')
				if _rc != 0 {
					loc teffect = 0
				}
				local t_effect = trim("`: display %9.3f `teffect''")
				if strpos("`var'", "index") {
					loc t_effect = "-"
				}
				
				local c_mean = subinstr(`"`c_mean'"', "0.", ".", .)
				local c_sd = subinstr(`"`c_sd'"', "0.", ".", .)
				local t_effect = subinstr(`"`t_effect'"', "0.", ".", .)
				
				estadd local c_mean `c_mean'
				estadd local c_sd `c_sd'
				estadd local t_effect `t_effect'
			}
			
			* Export Panel B or C
			esttab using `"`using'"', append ///
				posthead("\midrule \multicolumn{`num_outcomes'}{c}{\textbf{\textit{Panel `=char(`panelnum')' — `hetlab_`hetval''}}} \\ ") ///
				prefoot("[1ex]") nogaps nocons nolz label cells(b(fmt(a3) star) se(par fmt(a3)) p(par([ ]) fmt(a3))) ///
				fragment booktabs compress noobs nonumbers collabels(none) nomtitles keep(`treat') ///
				stats(c_mean c_sd t_effect N, labels("Control Mean" "Control SD" "Treatment Effect (\%)" "N")) ///
				star(* 0.10 ** 0.05 *** 0.01) nobase noomitted
			eststo clear
			
			local panelnum = `panelnum' + 1
		}
		
		****
		**## Panel D: Difference in coefficients (suest)
		****
		local diff "Diff "
		local chi2 "$\chi^2$ Stat "
		local pcompare "P-value "
		
		foreach var of varlist `varlist' {
			eststo clear
			local testindex = 1
			
			foreach hetval in `hetlevels' {
				if "`treat_only'" == "" {
					qui eststo: reg `var' `treat' `controls' if `hetvar' == `hetval'
				}
				else {
					qui eststo: reg `var' `treat' `controls' if `hetvar' == `hetval' | `treat' == 0
				}

				local coeff`testindex' = e(b)[1, 1]
				local testindex = `testindex' + 1
			}
			
			qui suest est1 est2 `regopts'
			qui test [est1_mean]`treat' = [est2_mean]`treat'
			
			local chi`var' "`: di %20.3f `r(chi2)''"
			local p`var' "`: di %20.3f `r(p)''"
			local d`var' = `coeff1' - `coeff2'
			local diff`var' "`: di %20.3f `d`var'''"
			
			* Remove leading zeros
			local chi`var' = subinstr(`"`chi`var''"', "0.", ".", .)
			local p`var' = subinstr(`"`p`var''"', "0.", ".", .)
			local diff`var' = subinstr(`"`diff`var''"', "0.", ".", .)
			
			local diff "`diff' & `diff`var''"
			local chi2 "`chi2' & `chi`var''"
			local pcompare "`pcompare' & `p`var''"
			eststo clear
		}
		
		* Write Panel D and table footer
		cap file close texoutput
		file open texoutput using `"`using'"', write append
		file write texoutput "\midrule" _n
		file write texoutput "\multicolumn{`num_outcomes'}{c}{\textbf{\textit{Panel `=char(`panelnum')' — Diff `hetlab_`level1'' `hetlab_`level2''}}} \\ " _n
		file write texoutput "`diff' \\ " _n
		file write texoutput "`chi2' \\ " _n
		file write texoutput "`pcompare' \\ " _n
		file write texoutput "\bottomrule" _n
		file write texoutput "\multicolumn{`num_outcomes'}{l}{\footnotesize Standard errors in parentheses} \\" _n
		file write texoutput "\multicolumn{`num_outcomes'}{l}{\footnotesize \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)} \\" _n
		file write texoutput "\end{tabular}" _n
		file close texoutput
		
		* Restore original dataset
		use `het_table_tempsave', clear

	end