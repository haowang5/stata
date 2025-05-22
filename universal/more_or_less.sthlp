{smcl}
{* *! version 1.01  30aug2024}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:more_or_less} — Module that creates indicator for higher/lower than median


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:more_or_less}
{it:varname}
{cmd:, {opt g:enerate(newvarname)}|{opth prefix(string)} [{opt bin(varlist)} {opt varlab:el(string)} {opt vallab:el(string)}]}

{marker Example}{...}
{title:Example}

{phang}
more_or_less earnings , prefix("higher_") bin(survey_wave gender) varlab("Indicator for higher than median earnings") vallab(0 "Lower than Median Earnings" 1 "Higher than Median Earnings")


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu

