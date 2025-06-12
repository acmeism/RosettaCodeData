/* REXX ***************************************************************
* Program to calculate and show divisors of positive integer(s).
* 03.08.2012 Walter Pachl  simplified the above somewhat
*            in particular I see no benefit from divAdd procedure
* 04.08.2012 the reference to 'above' is no longer valid since that
*            was meanwhile changed for the better.
* 04.08.2012 took over some improvements from new above
**********************************************************************/
Parse arg low high .
Select
  When low=''  Then Parse Value '1 200' with low high
  When high='' Then high=low
  Otherwise Nop
  End
do j=low to high
  say '   n = ' right(j,6) "   divisors = " divs(j)
  end
exit

divs: procedure; parse arg x
  if x==1 then return 1               /*handle special case of 1     */
  Parse Value '1' x With lo hi        /*initialize lists: lo=1 hi=x  */
  odd=x//2                            /* 1 if x is odd               */
  Do j=2+odd By 1+odd While j*j<x     /*divide by numbers<sqrt(x)    */
    if x//j==0 then Do                /*Divisible?  Add two divisors:*/
      lo=lo j                         /* list low divisors           */
      hi=x%j hi                       /* list high divisors          */
      End
    End
  If j*j=x Then                       /*for a square number as input */
    lo=lo j                           /* add its square root         */
  return lo hi                        /* return both lists           */
