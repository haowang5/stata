{smcl}
{* *! version 1.01  30aug2024}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:baltab} — Module that creates balance tables using iebaltab


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:baltab}
{it:varlist using}
, {opt refcat(string)} {opt booktabs} iebaltab_options

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt refcat}} Inspired by esttab's refcat, include extra rows in the table containing subtitles or other information such as panel names{p_end}
{synopt:{opt booktabs}}use boooktabs instead of \hline for aesthetic{p_end}

{synopt:iebaltab_options}Other options are identical to iebaltab's, with the exception that savetex() is disabled. Please use `"using "$path/..../file.tex" "' to specify export file{p_end}

{synoptline}


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu

