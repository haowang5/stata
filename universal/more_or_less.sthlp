{smcl}
{* *! version 1.02  22jan2026}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:more_or_less} — Module that creates indicator for higher/lower than median


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:more_or_less}
{it:varname}
{cmd:,} {c -(}{opt g:enerate(newvarname)}|{opt prefix(string)}{c )-}
[{opt includemedian} {opt invert} {opt varlab:el(string)} {opt vallab:el(string)}]

{p 8 15 2}
{cmd:bysort} {it:varlist}{cmd::} {cmd:more_or_less}
{it:varname}
{cmd:,} {c -(}{opt g:enerate(newvarname)}|{opt prefix(string)}{c )-}
[{it:options}]


{marker options}{...}
{title:Options}

{phang}
{opt g:enerate(newvarname)} specifies the name of the new indicator variable to be created.
Either {opt generate()} or {opt prefix()} must be specified, but not both.

{phang}
{opt prefix(string)} specifies a prefix to be added to the original variable name to create the new variable name.
The new variable will be named {it:prefix_varname}.
Either {opt generate()} or {opt prefix()} must be specified, but not both.

{phang}
{opt includemedian} specifies that observations equal to the median should be coded as 1 (higher) rather than the default of 0 (lower or equal).

{phang}
{opt invert} reverses the coding so that values below the median are coded as 1 and values at or above the median are coded as 0.

{phang}
{opt varlab:el(string)} specifies a variable label to be attached to the new variable.

{phang}
{opt vallab:el(string)} specifies value labels to be attached to the new variable.
The format is {it:# "label" # "label" ...}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:more_or_less} creates a binary indicator variable based on whether observations are above or below the median of the specified variable.
By default, observations strictly above the median are coded as 1, and observations at or below the median are coded as 0.

{pstd}
The command supports Stata's {cmd:by} prefix, allowing medians to be calculated separately within groups defined by one or more variables.


{marker examples}{...}
{title:Examples}

{pstd}Basic usage with generate:{p_end}
{phang2}{cmd:. more_or_less earnings, generate(high_earner)}{p_end}

{pstd}Using prefix to name the variable:{p_end}
{phang2}{cmd:. more_or_less earnings, prefix("higher")}{p_end}

{pstd}With variable and value labels:{p_end}
{phang2}{cmd:. more_or_less earnings, prefix("higher") varlabel("Indicator for higher than median earnings") vallabel(0 "Lower" 1 "Higher")}{p_end}

{pstd}Calculate medians separately by group using bysort:{p_end}
{phang2}{cmd:. bysort survey_wave gender: more_or_less earnings, generate(high_earner)}{p_end}

{pstd}Include median values as "higher":{p_end}
{phang2}{cmd:. more_or_less earnings, generate(high_earner) includemedian}{p_end}

{pstd}Invert coding (below median = 1):{p_end}
{phang2}{cmd:. more_or_less earnings, generate(low_earner) invert}{p_end}


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu

