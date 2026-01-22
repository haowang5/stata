{smcl}
{* *! version 1.00  22jan2026}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:wrap_varlab} — Wrap variable labels with line breaks for table display


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:wrap_varlab}
{varlist}
[{cmd:,} {opt maxc:hars(#)} {opt len:ient}]


{marker options}{...}
{title:Options}

{phang}
{opt maxc:hars(#)} specifies the maximum number of characters per line before wrapping.
The default is 15 characters.

{phang}
{opt len:ient} uses lenient wrapping logic. With this option, a new line is started only when the current line
already exceeds the maximum character limit. Without this option (strict mode), a new line is started before
adding a word that would cause the line to exceed the limit.


{marker description}{...}
{title:Description}

{pstd}
{cmd:wrap_varlab} modifies variable labels by inserting line break markers ({cmd:\\}) to wrap
long labels across multiple lines. This is useful for creating wrapped column headers in tables,
particularly when exporting to LaTeX or other formats that support the {cmd:\\} line break syntax.

{pstd}
The command processes each variable in {varlist}, takes its variable label (or variable name if no label exists),
and wraps it at word boundaries to fit within the specified character width. The modified label with line breaks
is then assigned back to the variable.


{marker examples}{...}
{title:Examples}

{pstd}Wrap labels at default 15 characters:{p_end}
{phang2}{cmd:. wrap_varlab income expenditure savings}{p_end}

{pstd}Wrap labels at 20 characters:{p_end}
{phang2}{cmd:. wrap_varlab income expenditure, maxchars(20)}{p_end}

{pstd}Use lenient wrapping (allows lines to exceed limit before breaking):{p_end}
{phang2}{cmd:. wrap_varlab income expenditure, maxchars(12) lenient}{p_end}

{pstd}Process all variables:{p_end}
{phang2}{cmd:. wrap_varlab _all, maxchars(18)}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
The difference between strict (default) and lenient modes:

{pstd}
{it:Strict mode}: A word is added to the current line only if it will not exceed {opt maxchars}.
If adding the word would exceed the limit, it starts a new line.

{pstd}
{it:Lenient mode}: Words are added to the current line until the line reaches or exceeds {opt maxchars},
then a new line is started. This may result in lines slightly longer than {opt maxchars}.


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu
