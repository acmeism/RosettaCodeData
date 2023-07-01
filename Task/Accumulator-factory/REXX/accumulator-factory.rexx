/*REXX program shows one method an   accumulator factory   could be implemented.        */
x=.accumulator(1)                                /*initialize accumulator with a 1 value*/
x=call(5)
x=call(2.3)
say '          X value is now'   x               /*displays the current value of   X.   */
say 'Accumulator value is now'  sum              /*displays the current value of  accum.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.accumulator:  procedure expose sum;   if symbol('SUM')=="LIT"  then sum=0   /*1st time?*/
               sum=sum + arg(1)                                              /*add──►sum*/
               return sum
/*──────────────────────────────────────────────────────────────────────────────────────*/
call:  procedure expose sum;  sum=sum+arg(1);    return sum          /*add arg1 ──► sum.*/
