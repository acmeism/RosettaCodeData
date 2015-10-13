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
iSqrt: procedure;  parse arg x;  q=1;  r=0;         do  while  q<=x;  q=q*4; end
         do  while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0  then do; x=_; r=r+q; end
         end   /*while ···*/
return r
/*────────────────────────────────────────────────────────────────────────────*/
sigma: procedure;  parse arg x;  if x<5  then return max(0,x-1);    sqX=iSqrt(x)
s=1;                  odd=x//2         /* [↓]  only use  EVEN or ODD integers.*/
     do j=2+odd  by 1+odd  to sqX      /*divide by all integers up to  √ x    */
     if x//j==0  then  s=s+j+ x%j      /*add the two divisors to (sigma) sum. */
     end   /*j*/                       /* [↑]  %  is the REXX integer division*/
                                       /* [↓]  adjust for a square.        ___*/
if sqx*sqx==x  then  s=s-j             /*Was X a square?  If so, subtract √ x */
return s                               /*return (sigma) sum of the divisors.  */
