/*REXX program to find and display  Fermat  numbers, and show factors of Fermat numbers.*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 9                     /*Not specified?  Then use the default.*/
numeric digits 20                                /*ensure enough decimal digits, for n=9*/

       do j=0  to n;   f= 2** (2**j)   +  1      /*calculate a series of Fermat numbers.*/
       say right('F'j, length(n) + 1)': '     f  /*display a particular     "      "    */
       end   /*j*/
say
       do k=0  to n;   f= 2** (2**k)   +  1; say /*calculate a series of Fermat numbers.*/
       say center(' F'k": " f' ', 79, "═")       /*display a particular     "      "    */
       p= factr(f)                               /*factor a Fermat number,  given time. */
       if words(p)==1  then say f ' is prime.'
                       else say 'factors: '   p
       end   /*k*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
factr:  procedure; parse arg x 1 z,,?
             do k=1  to 11  by 2;  j= k;  if j==1  then j= 2;  if j==9  then iterate
             call build                          /*add  J  to the factors list.         */
             end   /*k*/                         /* [↑]  factor  X  with some low primes*/

             do y=0  by 2;         j= j + 2 +   y // 4      /*ensure not  ÷  by three.  */
             parse var j '' -1 _;  if _==5  then iterate    /*last digit a "5"? Skip it.*/
             if j*j>x | j>z  then leave
             call build                          /*add  Y  to the factors list.         */
             end   /*y*/                         /* [↑]  factor  X  with other higher #s*/
        j= z
        if z\==1  then ?= build()
        if ?=''   then do;  @.1= x;  ?= x;  #= 1;  end
        return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
build:     do  while z//j==0;    z= z % j;    ?= ? j;    end;              return strip(?)
