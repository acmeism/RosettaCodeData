/*REXX program counts the number of  abundant/deficient/perfect  numbers within a range.*/
parse arg low high .                             /*obtain optional arguments from the CL*/
high=word(high low 20000,1);  low= word(low 1,1) /*obtain the   LOW  and  HIGH   values.*/
say center('integers from '   low   " to "   high,  45,  "═")        /*display a header.*/
!.= 0                                            /*define all types of  sums  to zero.  */
      do j=low  to high;           $= sigma(j)   /*get sigma for an integer in a range. */
      if $<j  then               !.d= !.d + 1    /*Less?      It's a  deficient  number.*/
              else if $>j  then  !.a= !.a + 1    /*Greater?     "  "  abundant      "   */
                           else  !.p= !.p + 1    /*Equal?       "  "  perfect       "   */
      end  /*j*/                                 /* [↑]  IFs are coded as per likelihood*/

say '   the number of perfect   numbers: '       right(!.p, length(high) )
say '   the number of abundant  numbers: '       right(!.a, length(high) )
say '   the number of deficient numbers: '       right(!.d, length(high) )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigma: procedure; parse arg x; if x<2  then return 0;  odd=x // 2    /* // ◄──remainder.*/
       s= 1                                      /* [↓]  only use  EVEN or ODD integers.*/
             do k=2+odd  by 1+odd  while k*k<x   /*divide by all integers up to  √x.    */
             if x//k==0  then  s= s + k +  x % k /*add the two divisors to (sigma) sum. */
             end   /*k*/                         /* [↑]  %  is the REXX integer division*/
       if k*k==x  then  return s + k             /*Was  X  a square?   If so, add  √ x  */
                        return s                 /*return (sigma) sum of the divisors.  */
