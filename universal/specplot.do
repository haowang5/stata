sysuse auto, clear



split make, gen(brand)

encode brand1, gen(car_brand)





***************Collect Coefficients of Price on Mpg

*Empty Tempfile

preserve

clear

tempfile coefs

save `coefs', replace emptyok

restore







***OLS Regressions

*No Controls

reg price mpg

local b=_b[mpg]

local se=_se[mpg]



reg price mpg, robust

local b_r=_b[mpg]

local se_r=_se[mpg]



reg price mpg, vce(cluster car_brand)

local b_c=_b[mpg]

local se_c=_se[mpg]



*Controls

reg price mpg headroom trunk weight length turn displacement gear_ratio

local bc=_b[mpg]

local sec=_se[mpg]



reg price mpg headroom trunk weight length turn displacement gear_ratio, robust

local bc_r=_b[mpg]

local sec_r=_se[mpg]



reg price mpg headroom trunk weight length turn displacement gear_ratio, vce(cluster car_brand)

local bc_c=_b[mpg]

local sec_c=_se[mpg]





**Controls and Fixed Effects

reg price mpg headroom trunk weight length turn displacement gear_ratio i.foreign i.car_brand

local bc_fe=_b[mpg]

local se_fe=_se[mpg]





reg price mpg headroom trunk weight length turn displacement gear_ratio i.foreign i.car_brand, robust

local bc_fe_r=_b[mpg]

local se_fe_r=_se[mpg]



reg price mpg headroom trunk weight length turn displacement gear_ratio i.foreign i.car_brand, vce(cluster car_brand)

local bc_fe_c=_b[mpg]

local se_fe_c=_se[mpg]





**************Set Up Dataset

preserve

clear

set obs 9

gen outcome="price"

gen method="ols"



gen std_error=""

replace std_error="" in 1/3

replace std_error="Robust" in 4/6

replace std_error="Clustered" in 7/9



gen controls=""

replace controls="No" if inlist(_n, 2, 5, 8)

replace controls="Yes" if controls==""



gen fixed_effects="Yes" if inlist(_n, 3, 6, 9)

replace fixed_effects="No" if fixed_effects==""





*********Input Estimates

gen coef=`b' in 1

replace coef=`bc' in 2

replace coef=`bc_fe' in 3



replace coef=`b_r' in 4

replace coef=`bc_r' in 5

replace coef=`bc_fe_r' in 6



replace coef=`b_c' in 7

replace coef=`bc_c' in 8

replace coef=`bc_fe_c' in 9



*******Input Associated Standard Errors

gen se=`se' in 1

replace se=`sec' in 2

replace se=`se_fe' in 3



replace se=`se_r' in 4

replace se=`sec_r' in 5

replace se=`se_fe_r' in 6



replace se=`se_c' in 7

replace se=`sec_c' in 8

replace se=`se_fe_c' in 9





append using `coefs'

save `coefs', replace

restore





*********Now Do IVS



*No Controls

ivregress 2sls price (mpg=weight)

local b=_b[mpg]

local se=_se[mpg]



ivregress 2sls price (mpg=weight), robust

local b_r=_b[mpg]

local se_r=_se[mpg]



ivregress 2sls price (mpg=weight), vce(cluster car_brand)

local b_c=_b[mpg]

local se_c=_se[mpg]



*Controls

ivregress 2sls price (mpg=weight) headroom trunk length turn displacement gear_ratio

local bc=_b[mpg]

local sec=_se[mpg]



ivregress 2sls price (mpg=weight) headroom trunk length turn displacement gear_ratio, robust

local bc_r=_b[mpg]

local sec_r=_se[mpg]



ivregress 2sls price (mpg=weight) headroom trunk length turn displacement gear_ratio, vce(cluster car_brand)

local bc_c=_b[mpg]

local sec_c=_se[mpg]





**Controls and Fixed Effects

ivregress 2sls price (mpg=weight) headroom trunk length turn displacement gear_ratio i.foreign i.car_brand

local bc_fe=_b[mpg]

local se_fe=_se[mpg]





ivregress 2sls price (mpg=weight) headroom trunk length turn displacement gear_ratio i.foreign i.car_brand, robust

local bc_fe_r=_b[mpg]

local se_fe_r=_se[mpg]



ivregress 2sls price (mpg=weight) headroom trunk length turn displacement gear_ratio i.foreign i.car_brand, vce(cluster car_brand)

local bc_fe_c=_b[mpg]

local se_fe_c=_se[mpg]



**************Set Up Dataset

preserve

clear

set obs 9

gen outcome="price"

gen method="iv"



gen std_error=""

replace std_error="" in 1/3

replace std_error="Robust" in 4/6

replace std_error="Clustered" in 7/9



gen controls=""

replace controls="No" if inlist(_n, 2, 5, 8)

replace controls="Yes" if controls==""



gen fixed_effects="Yes" if inlist(_n, 3, 6, 9)

replace fixed_effects="No" if fixed_effects==""





*********Input Estimates

gen coef=`b' in 1

replace coef=`bc' in 2

replace coef=`bc_fe' in 3



replace coef=`b_r' in 4

replace coef=`bc_r' in 5

replace coef=`bc_fe_r' in 6



replace coef=`b_c' in 7

replace coef=`bc_c' in 8

replace coef=`bc_fe_c' in 9



*******Input Associated Standard Errors

gen se=`se' in 1

replace se=`se_c' in 2

replace se=`se_fe' in 3



replace se=`se_r' in 4

replace se=`sec_r' in 5

replace se=`se_fe_r' in 6



replace se=`se_c' in 7

replace se=`sec_c' in 8

replace se=`se_fe_c' in 9





append using `coefs'

save `coefs', replace

restore





use `coefs', clear





************Set up for Chart Code



*********Variables for Categories



**Type of Estimation

gen ols=(method=="ols")

gen iv=(method=="iv")



*Controls used

gen no_controls=(controls=="No")

gen covariates=(controls=="Yes")

gen fes=(fixed_effects=="Yes")



*Standard Error Estimation

gen standard=(std_error=="")

gen robust=(std_error=="Robust")

gen clustered=(std_error=="Clustered")





**************Confidence Intervals and Ranking Lowest to Highest

sort coef

gen uci=coef+1.96*se

gen lci=coef-1.96*se



gen spec_id=_n

gen rank=spec_id





**# Bookmark #1

************Colors and Highlighted Specification

local gray gs10 /// This is the Light Gray Color



***Find Highlighted Specification to Color in vs other grays

quietly sum spec_id if clustered==1 & fes==1 & ols==1

local special_spec=r(mean)





***Figure Out How Many Specifications There Are

qui sum spec_id

local max=r(max)



local spec_p1=`special_spec'+1 

local spec_m1=`special_spec'-1 



di `spec_p1'

di `spec_m1'





**********Set Values for Where Our Buttons Start

sum uci lci



*y axis max is like 1500, y axis min is -3861

*So -4000 to 2000, 



local ncs=-4500

local covs=`ncs'-250

local fes=`covs'-250



local standard=`fes'-500

local robust=`standard'-250

local cluster=`robust'-250



local ols=`cluster'-500

local iv=`ols'-250





*************Now We Set up The Bottom Part of Graph with colored/empty dots



***Controls

local ind=-4500

	foreach var in no_controls covariates fes {

	   cap gen i_`var'=`ind'

	   local ind=`ind'-250

	   local scoff="`scoff' (scatter i_`var' rank,msize(vsmall) mcolor(gs10))" 

	   local scon="`scon' (scatter i_`var' rank if `var'==1,msize(vsmall) mcolor(black))" 

	}

	

*Standard Errors

	   local ind=`ind'-250

	foreach var in standard robust cluster{

	   cap gen i_`var'=`ind'

	   local ind=`ind'-250

	   local scoff="`scoff' (scatter i_`var' rank,msize(vsmall) mcolor(gs10))" 

	   local scon="`scon' (scatter i_`var' rank if `var'==1,msize(vsmall) mcolor(black))" 

	}

	

*Method

	   local ind=`ind'-250

	foreach var in ols iv{

	   cap gen i_`var'=`ind'

	   local ind=`ind'-250

	   local scoff="`scoff' (scatter i_`var' rank,msize(vsmall) mcolor(gs10))" 

	   local scon="`scon' (scatter i_`var' rank if `var'==1,msize(vsmall) mcolor(black))" 

	}



*****************Now We Set up Top Part of Graph: Each dot/bars is its own graph

forvalues n=1/`spec_m1' {

local graphs `graphs' (scatter coef spec_id if spec_id == `n', color(`gray') mfcolor(`gray') msymbol(D) msize(vsmall)) (rcap lci uci spec_id if spec_id == `n',  color(`gray') msize(vsmall)) 



}	





local graphs2 (scatter coef spec_id if spec_id == `special_spec', color(black) mfcolor(black) msymbol(D) msize(vsmall)) (rcap lci uci spec_id if spec_id == `special_spec',  color(black) msize(vsmall)) 

	



forvalues n=`spec_p1'/`max' {

local graphs `graphs' (scatter coef spec_id if spec_id == `n', color(`gray') mfcolor(`gray') msymbol(D) msize(vsmall)) (rcap lci uci spec_id if spec_id == `n',  color(`gray') msize(vsmall)) 



}





******************Now We Put it All Together in a Twoway Graph



#delimit ;

graph twoway `graphs' `graphs2' `scoff' `scon' , 

yline(0, lcolor(black))

legend(off)  

ylabel(2000 1000 0 -1000 -2000 -3000 -4000  `ncs' "No Controls" `covs' "Covariates" `fes' "Brand/Foreign Fixed Effects" `standard' "Classic Std. Errors" `robust' "Robust Std. Errors" `cluster' "Brand Clustered Std. Errors" `ols' "OLS" `iv' "IV",

angle(0) 

labsize(vsmall))

 yscale(noline) 

 xscale(noline) 

 xlab("", noticks) 

 graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white)) 

;





#delimit cr;



graph export "[YOUR PATH HERE]\Example Specification Curve.pdf", replace