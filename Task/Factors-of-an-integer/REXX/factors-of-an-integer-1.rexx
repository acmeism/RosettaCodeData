/*REXX program to calculate and show divisors of positive integer(s).   */
parse arg low high .;      high=word(high low 20,1);     low=word(low 1,1)
numeric digits max(9,length(high))     /*ensure modulus has enough digs.*/

         do n=low to high              /*the default range is:  1 ──> 20*/
         say 'divisors of' right(n,length(high)) " ──► " divisors(n)
         end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DIVISORS subroutine─────────────────*/
divisors: procedure; parse arg x 1 b; if x==1 then return 1; a=1; odd=x//2
                                       /*Odd? Then use only odd divisors*/
   do j=2+odd  by 1+odd  while j*j<x   /*divide by all integers up to √x*/
   if x//j\==0 then iterate            /*¬ divisible?  Then keep looking*/
   a=a j;   b=x%j b                    /*add a divisor to both lists.   */
   end   /*j*/

if j*j==x then b=j b                   /*Was X a square?  If so, add √x.*/
return a b                             /*return divisors (both lists).  */
