{smcl}
{* *! version 1.1  22jan2026}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:het_table} — Generate heterogeneity analysis table in LaTeX format


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:het_table}
{varlist}
{cmd:using} {it:filename}
{cmd:,}
{opt treat(varname)}
{opt regcmd(string)}
{opt hetvar(varname)}
[{opt breakline(#)}]
[{opt treat_only}]


{marker options}{...}
{title:Options}

{dlgtab:Required}

{phang}
{opt treat(varname)} specifies the treatment indicator variable.

{phang}
{opt regcmd(string)} specifies the control variables and regression options to be used in all regressions.
This can include both a list of control variables and options separated by a comma.
For example: {cmd:regcmd(age gender income, vce(cluster village))}.

{phang}
{opt hetvar(varname)} specifies the heterogeneity variable used to split the sample.
This variable must have exactly 2 distinct values.

{dlgtab:Optional}

{phang}
{opt breakline(#)} specifies the maximum number of characters per line in column headers before wrapping.
The default is 12 characters.

{phang}
{opt treat_only} specifies that the heterogeneity variable is observed only for the treatment group. 
When this option is specified, the command compares each subgroup of the treatment group (treated units with specific {opt hetvar} value) to the entire control group. 
This is useful when the heterogeneity dimension is only relevant or measured for treated units.


{marker description}{...}
{title:Description}

{pstd}
{cmd:het_table} creates a LaTeX table for heterogeneity analysis of treatment effects across multiple outcome variables.
The table contains four panels:

{phang2}• {bf:Panel A — Pooled}: Treatment effects estimated on the full sample.

{phang2}• {bf:Panel B}: Treatment effects for the first level of {opt hetvar}.

{phang2}• {bf:Panel C}: Treatment effects for the second level of {opt hetvar}.

{phang2}• {bf:Panel D}: Difference in treatment effects between the two groups, with chi-squared test statistics and p-values from {cmd:suest}.

{pstd}
For each regression, the table reports the coefficient, standard error (in parentheses), p-value (in brackets), control group mean,
control group standard deviation, treatment effect as a percentage of the control mean, and sample size.

{pstd}
The command uses value labels from {opt hetvar} to name the subgroup panels. The {cmd:elabel} package is required for extracting value labels.


{marker examples}{...}
{title:Examples}

{pstd}Basic usage:{p_end}
{phang2}{cmd:. het_table outcome1 outcome2 outcome3 using "het_results.tex", treat(treatment) regcmd(age gender) hetvar(female)}{p_end}

{pstd}With clustered standard errors:{p_end}
{phang2}{cmd:. het_table income savings expenditure using "het_table.tex", treat(treated) regcmd(age education, vce(cluster village)) hetvar(urban)}{p_end}

{pstd}With custom line break width:{p_end}
{phang2}{cmd:. het_table y1 y2 y3 using "results.tex", treat(T) regcmd(controls) hetvar(male) breakline(15)}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:Requirements:} This command requires the {cmd:estout} package for {cmd:esttab} and {cmd:eststo},
and the {cmd:elabel} package for extracting value labels.

{pstd}
{bf:Output format:} The output is a LaTeX fragment using booktabs formatting.
It includes the {cmd:\begin{c -(}tabular{c )-}} environment but not the {cmd:\begin{c -(}table{c )-}} float environment,
allowing you to wrap it as needed.

{pstd}
{bf:Treatment effect percentage:} For variables containing "index" in their name,
the treatment effect percentage is displayed as "-" since percentage effects are not meaningful for index variables.

{pstd}
{bf:Leading zeros:} Leading zeros are removed from all displayed statistics (e.g., 0.123 becomes .123).


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu
