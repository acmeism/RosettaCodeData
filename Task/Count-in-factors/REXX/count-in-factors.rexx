/*REXX program lists the prime factors of a specified integer (or range)*/
@.=left('',8);   @.0='{unity} ';   @.1='[prime] '  /*unity & prime tags.*/
parse arg low high .                   /*get the argument(s) from the CL*/
if  low==''  then do;low=1;high=40;end /*No LOW&HIGH?  Then use default.*/
if high==''  then high=low; oHigh=high /*No HIGH?      Then use the LOW.*/
w=length(high);   high=abs(high)       /*get max width for pretty tell. */
numeric digits max(9,w+1)              /*maybe bump precision of numbers*/
blanks=1                               /*1=allow spaces around the  "x".*/
primes=0                               /*number of primes detected.     */
         do n=low  to high             /*process single number | a range*/
         y=factr(n);                   /*squish  (or not)  the blanks.  */
         #=words(translate(y,,'x')) - (n==1)      /*# of prime factors. */
         if #==1  then primes=primes+1 /*bump primes counter (exclude 1)*/
         if high\==oHigh  then iterate /*only show factors if HIGH is >0*/
         say right(n,w) '=' @.# space(y,blanks)   /*prime flag, factors.*/
         end   /*n*/                   /*if BLANKS=0, no spaces around X*/
say
say right(primes,w)  ' primes found.'  /*display number of primes found.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FACTR subroutine────────────────────*/
factr: procedure;  parse arg x;  x=abs(x);  z=x  /*insure X is positive.*/
if x<2  then return x                  /*handle a couple special cases. */
list=                                  /*nullify the list (empty string)*/
                                       /* [↓]  process some low primes. */
  do j=2 to 5; if j\==4  then call .buildF; end  /*factorize, put──►list*/
  j=5                                  /*start where we left off (five).*/
       do y=0  by 2;     j=j+2+y//4    /*insure it's not divisible by 3.*/
       if right(j,1)==5  then iterate  /*fast check  for divisible by 5.*/
       if   j>z          then leave    /*number reduced to a small 'un? */
       if j*j>x          then leave    /*are we higher than the  √X  ?  */
       call .buildF                    /*add a prime factor to list (J).*/
       end    /*y*/

if z==1  then z=                       /*if residual is = 1, nullify it.*/
return strip(strip(list 'x' z),,"x")   /*elide a possible leading  "x". */
/*──────────────────────────────────.BUILDF subroutine──────────────────*/
.buildF:   do  while  z//j==0          /*keep dividing until it hurts.  */
           list=list 'x' j             /*add number to the list  (J).   */
           z=z%j                       /*do an integer divide.          */
           end   /*while*/
return
