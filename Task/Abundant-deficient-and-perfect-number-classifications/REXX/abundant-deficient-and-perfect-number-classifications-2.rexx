/*REXX program counts the number of  abundant/deficient/perfect  numbers within a range.*/
parse arg low high .                             /*obtain optional arguments from the CL*/
high=word(high low 20000,1);  low=word(low 1, 1) /*obtain the   LOW  and  HIGH   values.*/
say center('integers from '   low    " to "    high,  45,  "═")      /*display a header.*/
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
sigma: procedure; parse arg x 1 z;  if x<5  then return max(0, x-1)  /*sets X&Z to arg1.*/
       q=1;  do  while q<=z;  q= q * 4;     end  /* ◄──↓  compute integer sqrt of Z (=R)*/
       r=0;  do  while q>1; q=q%4; _=z-r-q; r=r%2; if _>=0  then do; z=_; r=r+q; end;  end
       odd= x//2                                 /* [↓]  only use EVEN | ODD ints.   ___*/
       s= 1;     do k=2+odd  by 1+odd  to r      /*divide by  all  integers up to   √ x */
                 if x//k==0  then  s=s + k + x%k /*add the two divisors to (sigma) sum. */
                 end   /*k*/                     /* [↑]  %  is the REXX integer division*/
       if r*r==x  then  return s - k             /*Was X a square?  If so, subtract √ x */
                        return s                 /*return (sigma) sum of the divisors.  */
