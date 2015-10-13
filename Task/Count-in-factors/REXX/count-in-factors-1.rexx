/*REXX program lists the  prime factors  of a specified integer  (or a range).*/
@.=left('',8); @.0='{unity} '; @.1='[prime] '; X='x' /*some tags and literals.*/
parse arg low high .                   /*get optional arguments from the C.L. */
if  low=='' then do;low=1;high=40; end /*No LOW & HIGH?  Then use the default.*/
if high=='' then high=low; tell=high>0 /*No HIGH?          "   "   "     "    */
w=length(high);   high=abs(high)       /*get maximum width for pretty output. */
numeric digits max(9,w+1)              /*maybe bump the precision of numbers. */
#=0                                    /*the number of primes found (so far). */
    do n=low  to high;     f=factr(n)  /*process a single number  or  a range.*/
    p=words(translate(f,,'x')) -(n==1) /*P:  is the number of prime factors.  */
    if p==1  then #=#+1                /*bump the primes counter (exclude N=1)*/
    if tell  then say right(n,w) '=' @.p space(f,0)   /*show if prime, factors*/
    end   /*n*/
say
say right(#,w)  ' primes found.'       /*display the number of primes found.  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
factr: procedure;  parse arg z 1 n,$;  if z<2  then return z
     do  while z// 2==0;  $=$ 'x 2' ;  z=z% 2; end  /*maybe add factor of   2 */
     do  while z// 3==0;  $=$ 'x 3' ;  z=z% 3; end  /*  "    "     "    "   3 */
     do  while z// 5==0;  $=$ 'x 5' ;  z=z% 5; end  /*  "    "     "    "   5 */
     do  while z// 7==0;  $=$ 'x 7' ;  z=z% 7; end  /*  "    "     "    "   7 */

    do j=11  by 6  while j<=z          /*insure that  J  isn't divisible by 3.*/
    parse var j  ''  -1  _             /*get the last decimal digit of  J.   */
    if _\==5  then do while z//j==0; $=$ 'x' j; z=z%j; end     /*maybe reduce.*/
    if _ ==3  then iterate             /*if next number will be ÷ by 3,  skip.*/
    if j*j>n  then leave               /*are we higher than the   √ N   ?     */
    y=j+2
                   do while z//y==0; $=$ 'x' y; z=z%y; end
    end   /*j*/

if z==1  then z=                       /*if residual is unity, then nullify it*/
return strip( strip( $ 'x' z), , 'x')  /*elide a possible leading (extra) "x".*/
