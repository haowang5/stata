program define wrap_varlab 
	version 14

	syntax varlist, [MAXchars(integer 15) LENient]
	
	foreach var of varlist `varlist' {
		* Get the variable label
		local varlab : variable label `var'
		
		* If no label, use variable name
		if "`varlab'" == "" {
			local varlab "`var'"
		}
		
		* Split label into words
		local result ""
		local current_line ""
		local current_len 0
		
		foreach word of local varlab {
			local wordlen = strlen("`word'")
			
			if "`lenient'" != "" {
				* Lenient logic: add next word as long as current line does not exceed limit
				if `current_len' >= `maxchars' & `current_len' > 0 {
					* Start new line
					if "`result'" == "" {
						local result "`current_line'"
					}
					else {
						local result "`result' \\ `current_line'"
					}
					local current_line "`word'"
					local current_len = `wordlen'
				}
				else {
					* Add word to current line
					if "`current_line'" == "" {
						local current_line "`word'"
						local current_len = `wordlen'
					}
					else {
						local current_line "`current_line' `word'"
						local current_len = `current_len' + 1 + `wordlen'
					}
				}
			}
			else {
				* Strict logic: add next word only if new length does not exceed limit
				if "`current_line'" == "" {
					local current_line "`word'"
					local current_len = `wordlen'
				}
				else {
					local new_len = `current_len' + 1 + `wordlen'
					if `new_len' <= `maxchars' {
						* Add word to current line
						local current_line "`current_line' `word'"
						local current_len = `new_len'
					}
					else {
						* Start new line with current word
						if "`result'" == "" {
							local result "`current_line'"
						}
						else {
							local result "`result' \\ `current_line'"
						}
						local current_line "`word'"
						local current_len = `wordlen'
					}
				}
			}
		}
		
		* Add the last line
		if "`current_line'" != "" {
			if "`result'" == "" {
				local result "`current_line'"
			}
			else {
				local result "`result' \\ `current_line'"
			}
		}

		lab var `var' `"\shortstack{`result'}"'
	}
end