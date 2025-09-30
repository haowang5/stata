******************************************
**# 1. Initialization & Data Preparation
******************************************

* Load example dataset and create car brand identifier
sysuse auto, clear
split make, gen(brand)
encode brand1, gen(car_brand)


********************************
**# 2. OLS Specification Curve
********************************

****
**## 2.1. No Controls
****

reg price mpg
local    b      = _b[mpg]
local    se     = _se[mpg]

reg price mpg, robust
local    b_r    = _b[mpg]
local    se_r   = _se[mpg]

reg price mpg, vce(cluster car_brand)
local    b_c    = _b[mpg]
local    se_c   = _se[mpg]

****
**## 2.2. Controls
****

reg price mpg headroom trunk weight length turn displacement gear_ratio
local    bc     = _b[mpg]
local    sec    = _se[mpg]

reg price mpg headroom trunk weight length turn displacement gear_ratio, robust
local    bc_r   = _b[mpg]
local    sec_r  = _se[mpg]

reg price mpg headroom trunk weight length turn displacement gear_ratio, vce(cluster car_brand)
local    bc_c   = _b[mpg]
local    sec_c  = _se[mpg]

****
**## 2.3. Controls + Fixed Effects
****

reg price mpg headroom trunk weight length turn displacement gear_ratio i.foreign i.car_brand
local    bc_fe   = _b[mpg]
local    se_fe   = _se[mpg]

reg price mpg headroom trunk weight length turn displacement gear_ratio i.foreign i.car_brand, robust
local    bc_fe_r = _b[mpg]
local    se_fe_r = _se[mpg]

reg price mpg headroom trunk weight length turn displacement gear_ratio i.foreign i.car_brand, vce(cluster car_brand)
local    bc_fe_c = _b[mpg]
local    se_fe_c = _se[mpg]


***************************************
**# 3. Assemble OLS Estimates Dataset
***************************************

preserve
clear
set obs 9

gen outcome        = "price"
gen method         = "ols"

gen std_error      = ""
replace std_error  = "Robust"    in 4/6
replace std_error  = "Clustered" in 7/9

gen controls       = "Yes"
replace controls   = "No" if inlist(_n, 2, 5, 8)

gen fixed_effects  = "No"
replace fixed_effects = "Yes" if inlist(_n, 3, 6, 9)

* Insert coefficient estimates
gen coef   = .
replace coef = `b'        in 1
replace coef = `bc'       in 2
replace coef = `bc_fe'    in 3
replace coef = `b_r'      in 4
replace coef = `bc_r'     in 5
replace coef = `bc_fe_r'  in 6
replace coef = `b_c'      in 7
replace coef = `bc_c'     in 8
replace coef = `bc_fe_c'  in 9

* Insert associated standard errors
gen se     = .
replace se = `se'       in 1
replace se = `sec'      in 2
replace se = `se_fe'    in 3
replace se = `se_r'     in 4
replace se = `sec_r'    in 5
replace se = `se_fe_r'  in 6
replace se = `se_c'     in 7
replace se = `sec_c'    in 8
replace se = `se_fe_c'  in 9

* Save temporary OLS estimates
tempfile coefs
drop if missing(coef)
save `coefs', replace
restore


*******************************
**# 4. IV Specification Curve
*******************************

****
**## 4.1. No Controls
****

ivregress 2sls price (mpg = weight)
local    b      = _b[mpg]
local    se     = _se[mpg]

ivregress 2sls price (mpg = weight), robust
local    b_r    = _b[mpg]
local    se_r   = _se[mpg]

ivregress 2sls price (mpg = weight), vce(cluster car_brand)
local    b_c    = _b[mpg]
local    se_c   = _se[mpg]

****
**## 4.2. Controls
****

ivregress 2sls price (mpg = weight) headroom trunk length turn displacement gear_ratio
local    bc     = _b[mpg]
local    sec    = _se[mpg]

ivregress 2sls price (mpg = weight) headroom trunk length turn displacement gear_ratio, robust
local    bc_r   = _b[mpg]
local    sec_r  = _se[mpg]

ivregress 2sls price (mpg = weight) headroom trunk length turn displacement gear_ratio, vce(cluster car_brand)
local    bc_c   = _b[mpg]
local    sec_c  = _se[mpg]

****
**## 4.3. Controls + Fixed Effects
****

ivregress 2sls price (mpg = weight) headroom trunk length turn displacement gear_ratio i.foreign i.car_brand
local    bc_fe   = _b[mpg]
local    se_fe   = _se[mpg]

ivregress 2sls price (mpg = weight) headroom trunk length turn displacement gear_ratio i.foreign i.car_brand, robust
local    bc_fe_r = _b[mpg]
local    se_fe_r = _se[mpg]

ivregress 2sls price (mpg = weight) headroom trunk length turn displacement gear_ratio i.foreign i.car_brand, vce(cluster car_brand)
local    bc_fe_c = _b[mpg]
local    se_fe_c = _se[mpg]


**************************************
**# 5. Assemble IV Estimates Dataset
**************************************

preserve
clear
set obs 9

gen outcome        = "price"
gen method         = "iv"

gen std_error      = ""
replace std_error  = "Robust"    in 4/6
replace std_error  = "Clustered" in 7/9

* Controls & fixed effects indicators


***Controls indicator
gen controls       = "Yes"
replace controls   = "No" if inlist(_n, 2, 5, 8)

***Fixed effects indicator
gen fixed_effects  = "No"
replace fixed_effects = "Yes" if inlist(_n, 3, 6, 9)

* Insert coefficient estimates

gen coef   = .
replace coef = `b'        in 1
replace coef = `bc'       in 2
replace coef = `bc_fe'    in 3
replace coef = `b_r'      in 4
replace coef = `bc_r'     in 5
replace coef = `bc_fe_r'  in 6
replace coef = `b_c'      in 7
replace coef = `bc_c'     in 8
replace coef = `bc_fe_c'  in 9

* Insert associated standard errors

gen se     = .
replace se = `se'       in 1
replace se = `sec'      in 2
replace se = `se_fe'    in 3
replace se = `se_r'     in 4
replace se = `sec_r'    in 5
replace se = `se_fe_r'  in 6
replace se = `se_c'     in 7
replace se = `sec_c'    in 8
replace se = `se_fe_c'  in 9

append using `coefs'
save `coefs', replace
restore


**********************************
**# 6. Prepare Data for Graphing
**********************************

use `coefs', clear

****
**## 6.1. Create Category Dummies
****

gen ols          = (method == "ols")
gen iv           = (method == "iv")

gen no_controls  = (controls == "No")
gen covariates   = (controls == "Yes")
gen fes          = (fixed_effects == "Yes")

gen standard     = (std_error == "")
gen robust       = (std_error == "Robust")
gen clustered    = (std_error == "Clustered")

****
**## 6.2. Confidence Intervals & Ordering
****

sort coef
gen uci  = coef + 1.96 * se
gen lci  = coef - 1.96 * se
gen spec_id = _n
gen rank    = spec_id

****
**## 6.3. Color & Highlighting
****

local gray gs10                                  * Light gray color
quietly sum spec_id if clustered == 1 & fes == 1 & ols == 1
local special_spec = r(mean)

quietly sum spec_id
local max = r(max)
local spec_p1 = `special_spec' + 1
local spec_m1 = `special_spec' - 1

****
**## 6.4. Axis & Button Positions
****

sum uci lci, meanonly
local ncs      = -4500
local covs     = `ncs' - 250
local fes_pos  = `covs' - 250
local standard = `fes_pos' - 500
local robust   = `standard' - 250
local cluster  = `robust' - 250
local ols_pos  = `cluster' - 500
local iv_pos   = `ols_pos' - 250


*******************************
**# 7. Build Graph Components
*******************************

****
**## 7.1. Bottom Indicator Dots
****

local scoff ""       // Off (gray) points
local scon  ""       // On (black) points
local ind   = -4500  // Starting y-position for buttons

* Controls
foreach var in no_controls covariates fes {
	cap gen i_`var' = `ind'
	local ind       = `ind' - 250
	local scoff     = "`scoff' (scatter i_`var' rank, msize(vsmall) mcolor(gs10))"
	local scon      = "`scon'  (scatter i_`var' rank if `var' == 1, msize(vsmall) mcolor(black))"
}

* Standard Errors
local ind = `ind' - 250
foreach var in standard robust clustered {
	cap gen i_`var' = `ind'
	local ind       = `ind' - 250
	local scoff     = "`scoff' (scatter i_`var' rank, msize(vsmall) mcolor(gs10))"
	local scon      = "`scon'  (scatter i_`var' rank if `var' == 1, msize(vsmall) mcolor(black))"
}

* Estimation Method
local ind = `ind' - 250
foreach var in ols iv {
	cap gen i_`var' = `ind'
	local ind       = `ind' - 250
	local scoff     = "`scoff' (scatter i_`var' rank, msize(vsmall) mcolor(gs10))"
	local scon      = "`scon'  (scatter i_`var' rank if `var' == 1, msize(vsmall) mcolor(black))"
}

****
**## 7.2. Top Confidence Interval Bars & Dots
****

local graphs ""

forvalues n = 1 / `spec_m1' {
	local graphs = "`graphs' (scatter coef spec_id if spec_id == `n', color(`gray') mfcolor(`gray') msymbol(D) msize(vsmall)) (rcap lci uci spec_id if spec_id == `n', color(`gray') msize(vsmall))"
}

local graphs2 "(scatter coef spec_id if spec_id == `special_spec', color(black) mfcolor(black) msymbol(D) msize(vsmall)) (rcap lci uci spec_id if spec_id == `special_spec', color(black) msize(vsmall))"

forvalues n = `spec_p1' / `max' {
	local graphs = "`graphs' (scatter coef spec_id if spec_id == `n', color(`gray') mfcolor(`gray') msymbol(D) msize(vsmall)) (rcap lci uci spec_id if spec_id == `n', color(`gray') msize(vsmall))"
}


*********************************
**# 8. Draw Specification Curve
*********************************

#delimit ;
graph twoway `graphs' `graphs2' `scoff' `scon',
	yline(0, lcolor(black))
	legend(off)
	ylabel(2000 1000 0 -1000 -2000 -3000 -4000  `ncs' "No Controls" `covs' "Covariates" `fes_pos' "Brand/Foreign Fixed Effects" `standard' "Classic Std. Errors" `robust' "Robust Std. Errors" `cluster' "Brand Clustered Std. Errors" `ols_pos' "OLS" `iv_pos' "IV", angle(0) labsize(vsmall))
	yscale(noline)
	xscale(noline)
	xlab("", noticks)
	graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white))
;
#delimit cr


***********************
**# 9. Export Graphic
***********************

graph export "[YOUR PATH HERE]\Example Specification Curve.pdf", replace

* End of script
