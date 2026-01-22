{smcl}
{* *! version 1.00  22jan2026}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:simpleindex} — Create a standardized index from multiple variables


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:simpleindex}
{varlist}
{cmd:,}
{opt gen:erate(newvarname)}
[{opt fl:ip(varlist)} {opt normby(varname)} {opt varlab:el(string)}]

{p 8 15 2}
{cmd:bysort} {it:varlist}{cmd::} {cmd:simpleindex}
{varlist}
{cmd:,}
{opt gen:erate(newvarname)}
[{it:options}]


{marker options}{...}
{title:Options}

{phang}
{opt gen:erate(newvarname)} specifies the name of the new index variable to be created. This option is required.

{phang}
{opt fl:ip(varlist)} specifies variables that should be flipped (multiplied by -1) before averaging.
Use this for variables where higher values indicate a worse outcome when the index should measure a positive outcome, or vice versa.

{phang}
{opt normby(varname)} specifies a binary indicator variable (typically a control group indicator) used for normalization.
When specified, the mean and standard deviation used for standardization are calculated only from observations where this variable equals 1.

{phang}
{opt varlab:el(string)} specifies a variable label to be attached to the new index variable.


{marker description}{...}
{title:Description}

{pstd}
{cmd:simpleindex} creates a standardized index by:

{phang2}1. Z-scoring each component variable (subtracting the mean and dividing by the standard deviation).

{phang2}2. Optionally flipping specified variables (multiplying by -1).

{phang2}3. Taking the row mean of the z-scored components.

{phang2}4. Re-standardizing the resulting mean to have mean 0 and standard deviation 1.

{pstd}
The command supports Stata's {cmd:by} prefix, allowing indices to be calculated separately within groups.
This is useful when creating indices separately by survey wave or other grouping variables.

{pstd}
When {opt normby()} is specified, standardization is performed using the mean and standard deviation
from the reference group (where the normby variable equals 1), but the index is created for all observations.


{marker examples}{...}
{title:Examples}

{pstd}Basic usage:{p_end}
{phang2}{cmd:. simpleindex var1 var2 var3, generate(myindex)}{p_end}

{pstd}Flip a variable so higher values indicate worse outcomes:{p_end}
{phang2}{cmd:. simpleindex income savings debt, generate(wealth_index) flip(debt)}{p_end}

{pstd}Standardize relative to the control group:{p_end}
{phang2}{cmd:. simpleindex var1 var2 var3, generate(myindex) normby(control)}{p_end}

{pstd}Create index separately by survey wave:{p_end}
{phang2}{cmd:. bysort survey_round: simpleindex var1 var2 var3, generate(myindex)}{p_end}

{pstd}Full example with all options:{p_end}
{phang2}{cmd:. bysort survey_round: simpleindex var1 var2 var3, gen(sample_index) flip(var3) normby(control) varlabel("Sample Index")}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
If all component variables are missing for all observations in a by-group, the index is set to missing for that group.

{pstd}
See also {help maindex} for creating a Michael Anderson (2008) index using inverse covariance weighting.


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu
