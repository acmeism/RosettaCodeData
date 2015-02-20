/*REXX pgm displays values when integers have an  overflow or underflow.*/
numeric digits 9                       /*default is nine decimal digits.*/
call  showResult(  999999997 + 1 )
call  showResult(  999999998 + 1 )
call  showResult(  999999999 + 1 )
call  showResult( -999999998 - 2 )
call  showResult(  40000 * 25000 )
call  showResult( -50000 * 20000 )
call  showResult(  50000 *-30000 )
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWRESULT subroutine───────────────*/
showResult:  procedure;  parse arg x,,_;       x=x/1     /*normalize X. */
if pos('E',x)\==0  then  if x>0  then _=' [overflow]'    /*did it ↑flow?*/
                                 else _=' [underflow]'   /*did it ↓flow?*/
say right(x,20) _                                        /*show result. */
return x                                                 /*return value.*/
