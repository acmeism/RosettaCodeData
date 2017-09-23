/*REXX program shows ranges of numbers  with  ordinal  (st/nd/rd/th)  suffixes attached.*/
call tell     0,    25                           /*display the  1st  range of numbers.  */
call tell   250,   265                           /*   "     "   2nd    "    "    "      */
call tell  1000,  1025                           /*   "     "   3rd    "    "    "      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: procedure; parse arg L,H,,$                /*get the Low and High #s, nullify list*/
           do j=L  to  H;   $=$ th(j);   end     /*process the range, from low ───► high*/
      say 'numbers from  '    L    " to "    H    ' (inclusive):'  /*display the title. */
      say strip($);    say;     say                                /*display line; 2 sep*/
      return                                                       /*return to invoker. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
th: parse arg z; x=abs(z); return z||word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
