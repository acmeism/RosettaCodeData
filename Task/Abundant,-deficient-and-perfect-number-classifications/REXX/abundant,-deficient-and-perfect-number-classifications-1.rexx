/*REXX pgm counts the number of abundant/deficient/perfect numbers in a range.*/
parse arg low high .                            /*get optional args from C.L. */
high=word(high low 20000,1);  low=word(low 1,1) /*get the LOW and HIGH values.*/
say center('integers from '   low   " to "   high,  45,  "═")
!.=0                                   /*define all types of  sums  to zero.  */
      do j=low  to high;   $=sigma(j)  /*find the sigma for an integer range. */
      if $<j  then               !.d=!.d+1        /*it's a  deficient  number.*/
              else if $>j  then  !.a=!.a+1        /*  "  "  abundant      "   */
                           else  !.p=!.p+1        /*  "  "  perfect       "   */
      end  /*j*/

say '   the number of perfect   numbers: '       right(!.p, length(high))
say '   the number of abundant  numbers: '       right(!.a, length(high))
say '   the number of deficient numbers: '       right(!.d, length(high))
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sigma: procedure;  parse arg x;   if x<2  then return 0;  odd=x//2     /*odd? */
s=1                                    /* [↓]  only use  EVEN or ODD integers.*/
    do j=2+odd  by 1+odd  while j*j<x  /*divide by all integers up to  √x.    */
    if x//j==0  then  s=s+j+ x%j       /*add the two divisors to (sigma) sum. */
    end   /*j*/                        /* [↑]  %  is the REXX integer division*/
                                       /* [↓]  adjust for a square.       ___ */
if j*j==x  then  s=s+j                 /*Was  X  a square?   If so, add  √ x  */
return s                               /*return (sigma) sum of the divisors.  */
