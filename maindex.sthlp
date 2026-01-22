{smcl}
{* *! version 1.00  22jan2026}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:maindex} — Create a Michael Anderson (2008) index using inverse covariance weighting


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:maindex}
{varlist}
{cmd:,}
{opt gen:erate(newvarname)}
[{opt fl:ip(varlist)} {opt normby(varname)} {opt varlab:el(string)}]

{p 8 15 2}
{cmd:bysort} {it:varlist}{cmd::} {cmd:maindex}
{varlist}
{cmd:,}
{opt gen:erate(newvarname)}
[{it:options}]


{marker options}{...}
{title:Options}

{phang}
{opt gen:erate(newvarname)} specifies the name of the new index variable to be created. This option is required.

{phang}
{opt fl:ip(varlist)} specifies variables that should be flipped before index construction.
Use this for variables where higher values indicate a worse outcome when the index should measure a positive outcome, or vice versa.

{phang}
{opt normby(varname)} specifies a binary indicator variable (typically a control group indicator) used for normalization.
When specified, standardization is performed using only observations where this variable equals 1.

{phang}
{opt varlab:el(string)} specifies a variable label to be attached to the new index variable.


{marker description}{...}
{title:Description}

{pstd}
{cmd:maindex} creates a summary index following the methodology described in Anderson (2008).
This approach uses inverse covariance weighting to optimally combine multiple outcome measures into a single index,
giving less weight to outcomes that are highly correlated with each other.

{pstd}
The command is a wrapper for {cmd:swindex} by Schwab et al., providing a simplified interface with support for
Stata's {cmd:by} prefix.

{pstd}
The command supports Stata's {cmd:by} prefix, allowing indices to be calculated separately within groups.
This is useful when creating indices separately by survey wave or other grouping variables.


{marker examples}{...}
{title:Examples}

{pstd}Basic usage:{p_end}
{phang2}{cmd:. maindex var1 var2 var3, generate(myindex)}{p_end}

{pstd}Flip a variable so higher values indicate worse outcomes:{p_end}
{phang2}{cmd:. maindex income savings debt, generate(wealth_index) flip(debt)}{p_end}

{pstd}Standardize relative to the control group:{p_end}
{phang2}{cmd:. maindex var1 var2 var3, generate(myindex) normby(control)}{p_end}

{pstd}Create index separately by survey wave:{p_end}
{phang2}{cmd:. bysort survey_round: maindex var1 var2 var3, generate(myindex)}{p_end}

{pstd}Full example with all options:{p_end}
{phang2}{cmd:. bysort survey_round: maindex var1 var2 var3, gen(sample_index) flip(var3) normby(control) varlabel("Sample Index")}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:Requirements:} This command requires the {cmd:swindex} package. Install it using:

{phang2}{cmd:. ssc install swindex}{p_end}

{pstd}
If all component variables are missing for all observations in a by-group, the index is set to missing for that group.

{pstd}
See also {help simpleindex} for creating a simple standardized index using equal weighting.


{marker references}{...}
{title:References}

{pstd}
Anderson, Michael L. 2008. "Multiple Inference and Gender Differences in the Effects of Early Intervention:
A Reevaluation of the Abecedarian, Perry Preschool, and Early Training Projects."
{it:Journal of the American Statistical Association} 103(484): 1481-1495.


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu
