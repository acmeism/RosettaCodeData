MCSKIP "WITH" NL
"" 99 bottles - recursive version
MCSKIP MT,<>
MCINS %.
"" Macro to generate singular or plural bottle(s)
MCDEF BOT WITHS () AS <bottle<>MCGO L0 IF %A1. EN 1
s>
"" Main macro - recurses for each verse - argument is initial number of bottles
MCDEF BOTTLES NL AS <MCSET T1=%A1.
%T1. BOT(%T1.) of beer on the wall
%T1. BOT(%T1.) of beer
Take one down, pass it around
MCSET T1=T1-1
%T1. BOT(%T1.) of beer on the wall
MCGO L0 IF T1 EN 0

BOTTLES %T1.
>
"" Do it
BOTTLES 99
