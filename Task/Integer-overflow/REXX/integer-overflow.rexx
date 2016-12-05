/*REXX program  displays values  when  integers  have an   overflow  or  underflow.     */
numeric digits 9                                 /*the REXX default is 9 decimal digits.*/
call  showResult(  999999997 + 1 )
call  showResult(  999999998 + 1 )
call  showResult(  999999999 + 1 )
call  showResult( -999999998 - 2 )
call  showResult(  40000 * 25000 )
call  showResult( -50000 * 20000 )
call  showResult(  50000 *-30000 )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showResult: procedure;  parse arg x,,_;  x=x/1                      /*normalize   X.    */
            if pos(., x)\==0  then  if x>0  then _=' [overflow]'    /*did it  overflow? */
                                            else _=' [underflow]'   /*did it underflow? */
            say right(x, 20) _                                      /*show the result.  */
            return x                                                /*return the value. */
