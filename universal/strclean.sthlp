{smcl}
{* *! version 1.01  30aug2024}{...}

{marker title}{...}
{title:Title}

{p 8 15 2}
{cmd:strclean} — Module that cleans string variables


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:strclean}
{it:varlist}
{cmd:, {opt replace}|{opth g:enerate(newvarlist)}|{opt suffix(string)} [{opt upper}|{opt lower}|{opt proper}] [{opt ascii} {opt notrim} {opt keepc:har(string)} {opt keepp:pattern(string)}]}

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:*{opt upper}}apply Stata's {cmd:strupper} function to the variable(s){p_end}
{synopt:*{opt lower}}apply Stata's {cmd:strlower} function to the variable(s){p_end}
{synopt:*{opt proper}}apply Stata's {cmd:strproper} function to the variable(s){p_end}

{synopt:+{opt replace}}replace the original variable(s) with the cleaned variable(s){p_end}
{synopt:+{opth g:enerate(newvarlist)}}generate new variable(s), with varname(s) specified by the user{p_end}
{synopt:+{opt suffix(string)}}generate new variable(s), whose varanme(s) are the original varname plus "_`suffix'"{p_end}

{synopt:{opt ascii}}convert characters to ASCII, skip characters that cannot be converted{p_end}
{synopt:{opt notrim}}the program by default removes leading and trailing spaces, and removes duplicated internal blanks. If notrim is specified it will not do anything to the spaces{p_end}
{synopt:{opt keepc:har(string)}}keep only characters that match the use specified Regex experssion{p_end}
{synopt:{opt keepp:pattern(string)}}keep only the first pattern that matches the use specified Regex experssion{p_end}
{synoptline}
{p2colreset}{...}
{pstd}
* {opt upper} {opt lower} {opt proper} are mutually exclusive.{break}
+ Must select one of {opt replace} {opt g:enerate} {opt suffix}.

{marker cleaningprocess}{...}
{title:Cleaning Process}

{phang}
Please note that program first applies ascii conversion (if specified), then trims leading, trailing and duplicated spaces (if {opt notrim} not specified), after that applies case conversion ({opt upper}|{opt lower}|{opt proper}, if specified), and at last applies keepchar/keeppattern (if specified).

{marker options}{...}
{title:Options}

{phang}
{opth g:enerate(newvarlist)} creates new variables containing the cleaned string variables. The number of new variable names specified in this option must be equal to the number of variables to be cleaned. 

{phang}
{opt keepc:har(string)} takes a string containing Regex expressions of characters. An example is that specifying {cmd:keepchar}({it:"A-z0-9\s"}) will remove all characters that are not alphabets, numbers, or spaces.

{phang}
{opt keepp:attern(string)} takes a string containing Regex expressions of characters. An example is that specifying {cmd:keeppattern}({it:"Y\d+"}) will keep the first substring that starts with Y and followed by numbers.

{phang}
The remaining options are self-explanatory.


{marker author}{...}
{title:Author}

Hao Wang{break}
wanghao@berkeley.edu

