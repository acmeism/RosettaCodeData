/*REXX pgm: acculation factory copied/modeled after the ooRexx program. */
x=.accumulator(new(1))                 /*set accumulater with init val 1*/
x=call(5)
x=call(2.3)
say "          X value is now"  x      /*displays current value of X.   */
say "Accumulator value is now"  sum    /*displays current value of accum*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
.accumulator:  procedure expose sum
               if symbol('SUM')=='LIT' then sum=0;     sum=sum+arg(1)
               return sum
call: procedure expose sum; sum=sum+arg(1); return sum /*adds arg1──►sum*/
new:  procedure;  return arg(1)        /*long way 'round of using one.  */
