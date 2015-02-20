/*REXX program displays if an integer  is    even    or    odd.         */
numeric digits 1000                   /*handle most big 'uns from the CL*/
parse arg x _ .                       /*get arg(s) from the command line*/
if x==''               then call terr 'no input'
if _\=='' | arg()\==1  then call terr 'too many arguments: ' arg(1)
if \datatype(x,'N')    then call terr x " isn't numeric"
if \datatype(x,'W')    then call terr x " isn't an integer"
y=abs(x)/1                            /*just in case   X   is negative, */
                                      /*(remainder of neg # might be -1)*/
                    /*══════════════════════════════════════════════════*/
                    say center('test using remainder)method',40,'─')
if y//2  then say  x  'is odd'
         else say  x  'is even'
                    /*══════════════════════════════════════════════════*/
say;                say center('test rightmost digit for evenness',40,'─')
_=right(y,1)
if pos(_,02468)==0  then say  x  'is odd'
                    else say  x  'is even'
                    /*══════════════════════════════════════════════════*/
say;                say center('test rightmost digit for oddness',40,'─')
if pos(right(y,1),13579)==0  then say  x  'is even'
                             else say  x  'is odd'
                    /*══════════════════════════════════════════════════*/
say;                say center('test rightmost (binary) bit',40,'─')
if right(x2b(d2x(y)),1)  then say  x  'is odd'
                         else say  x  'is even'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TERR subroutine─────────────────────*/
terr:  say;   say '***error!***';    say;   say arg(1);    say;    exit 13
