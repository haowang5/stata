{smcl}
{* *! version 2.1.0  16may2025}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:baltab} — Module that creates balance tables



{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:baltab}
{it:varlist using}
, {opt refcat(string)} {opt booktabs} {opt testorder} iebaltab_options

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt refcat}} Inspired by esttab's refcat, include extra rows in the table containing subtitles or other information such as panel names{p_end}
{synopt:{opt booktabs}}Use boooktabs instead of \hline for aesthetic{p_end}
{synopt:{opt testorder}}Order t-tests conducted. Takes string like "1_2 3_4", which means conducting a t-test between groupvar == 1 and groupvar == 2, then conducting a test between groupvar == 3 and groupvar == 4{p_end}

{synopt:iebaltab_options}Other options are identical to iebaltab's, with the exception that savetex() is disabled. Please use `"using "$path/..../file.tex" "' to specify export file{p_end}

{synoptline}


{marker Acknowledgement}{...}
{title:Acknowledgement}
This program is a fork of iebaltab (version 7.3 20240404), developed by DIME{break}


{marker author}{...}
{title:Author}
Hao Wang wanghao@berkeley.edu
{break}
version 2.1.0  16may2025

