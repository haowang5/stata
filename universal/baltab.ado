	* Purpose: Add booktabs and optional extra rows (often as panel names) to tables created by iebaltab
	* options:
		* booktabs: use boooktabs instead of \hline for aesthetic
		* refcat: Inspired by esttab's refcat, include extra rows in the table containing subtitles or other information such as panel names
		* Other options are identical to iebaltab's, with the exception that savetex() is disabled. Please use `" using "$path/..../file.tex" "' to specify export file
	* Author: Hao Wang
	* Last Edited: SEP 3 2024

	program define baltab
		
		version 14
		
		syntax varlist using/ [if] [, refcat(string asis)] [booktabs] [*]
		
		assert strpos("`options", "savetex") == 0
		assert strpos("`options'", " if ") == 0
		foreach i of varlist `varlist' {
			assert strpos("`options'", "`i'") == 0
		}
		
		
		local replace_text "replace"
		if strpos(`"`options'"', "replace") local replace_text ""
		
		local nonote_text "nonote"
		if strpos(`"`options'"', "nonote") local nonote_text ""
		
		local starlevels_text "starlevels(0.1 0.05 0.01)"
		if strpos(`"`options'"', "starlevels") local starlevels_text ""
		
		
		local ieoptions `"`varlist' `if' , `options' savetex(`"`using'"') `replace_text' `nonote_text' `starlevels_text' "'
		iebaltab `ieoptions'
		
		
		local andsigns "& & & & & &"
		if strpos(`"`ieoptions'"', " total") local andsigns "& & & & & & & &"
		local num_cols = 6
		if strpos(`"`ieoptions'"', " total") local num_cols = 8
		
		local hasrefcat = 0
		local n_vars : word count `varlist'
		if `"`refcat'"' != "" {
			local nref = 0
			gettoken curr_ref refcat : refcat
			while `"`curr_ref'"' != "" {
				local curr_ref`=`nref'+1' `"`curr_ref'"'
				if mod(`nref',2) == 0 assert strpos("`varlist'", "`curr_ref'")
				gettoken curr_ref refcat : refcat
				local nref = `nref' + 1 
			}
			assert mod(`nref',2) == 0
			
			
			
			local nvars : word count `varlist'
			local curr_row = 12
			foreach i of varlist `varlist' {
				local `i'_row = `curr_row'
				local curr_row = `curr_row' + 2
			}
			
			local hasrefcat = 1
		}
	
		
		
		cap file close myfile
		cap file close myfile_r
		file open myfile using `"`using'"', read
		file open myfile_r using "tempbaltab.tex", text write replace
		
		
		file read myfile line_file
		local curr_row = 1
		while r(eof)==0 {
			if "`booktabs'" != "" {
				if strpos(`"`line_file'"', "\\[-1.8ex]\hline \hline \\[-1.8ex]") {
					local line_file = "\\[-1.8ex]\toprule \\[-1.8ex]"
				}
				if strpos(`"`line_file'"', "\\ \hline \\[-1.8ex]"){
					local line_file : subinstr local line_file "\hline" "\midrule", all
				}
				if strpos(`"`line_file'"',"\hline \hline \\[-1.8ex]") {
					local line_file = "\bottomrule \\[-1.8ex]"
				}
			}
			
			if `hasrefcat' == 1 {
				forval j = 1(2)`=`nref'-1' {
					if ``curr_ref`j''_row' == `curr_row' file write myfile_r "\textbf{\textit{`curr_ref`=`j'+1''}} `andsigns' \\" _n
				}
				if `curr_row' >= 12 & `curr_row' <= `=10 + 2*`n_vars'' & mod(`curr_row',2) == 0 local line_file `"\quad `line_file'"'
			}
			
			if strpos(`"`line_file'"', "\end{tabular}") {
				if "`leebounds'" != "" file write myfile_r "multicolumn{`num_cols'}{l}{\footnotesize \cite{LeeDavidS2009Twas} bounds in brackets}\\" _n
				file write myfile_r "\multicolumn{`num_cols'}{l}{\footnotesize \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)}\\" _n
			}
				
			file write myfile_r `"`line_file'"' _n
			file read myfile line_file
			local curr_row = `curr_row' + 1
		}
		
		file close myfile
		file close myfile_r
		
		erase `"`using'"'
		copy "tempbaltab.tex" `"`using'"' , replace
		erase "tempbaltab.tex"
	
	end
