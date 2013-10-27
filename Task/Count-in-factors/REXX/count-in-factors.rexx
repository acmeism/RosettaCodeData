/*REXX program lists the prime factors of a specified integer (or range)*/
parse arg low high .                   /*get the argument(s) from the CL*/
if  low==''  then do;low=1;high=40;end /*No LOW&HIGH?  Then use default.*/
if high==''  then high=low             /*No HIGH?      Then use the LOW.*/
w=length(high)                         /*get max width for pretty tell. */
numeric digits max(9,w+1)              /*maybe bump precision of numbers*/
blanks=1                               /*1=allow spaces around the  "x".*/
         do n=low  to high             /*process single number | a range*/
         y=space(factr(n),blanks)      /*squish  (or not)  the blanks.  */
         say right(n,w) '=' left('',9*(words(y)\==1|n==1)) y  /*factors.*/
                       /*   ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑  indentation.*/
          end   /*n*/                   /*if BLANKS=0, no spaces around X*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FACTR subroutine────────────────────*/
factr: procedure;  parse arg x;  x=abs(x);  z=x  /*insure X is positive.*/
if x<2  then return x                  /*handle a couple special cases. */
Xtimes= 'x'                            /*character used for "times" (x).*/
list=                                  /*nullify the list (empty string)*/
                                       /* [↓]  process some low primes. */
  do j=2 to 5; if j\==4  then call .buildF; end  /*factorize, put──►list*/
  j=5                                  /*start were we left off  (five).*/
       do y=0  by 2;     j=j+2+y//4    /*insure it's not divisible by 3.*/
       if right(j,1)==5  then iterate  /*fast check  for divisible by 5.*/
       if   j>z          then leave    /*number reduced to a small 'un? */
       if j*j>x          then leave    /*are we higher than the  √X  ?  */
       call .buildF                    /*add a prime factor to list (J).*/
       end    /*y*/

if z==1  then z=                       /*if residual is = 1, nullify it.*/
return strip(strip(list Xtimes z),,Xtimes)    /*elide any leading  "x". */
/*──────────────────────────────────.BUILDF subroutine──────────────────*/
.buildF:   do  while  z//j==0          /*keep dividing until it hurts.  */
           list=list Xtimes j          /*add number to the list  (J).   */
           z=z%j                       /*do an integer divide.          */
           end   /*while*/
return
