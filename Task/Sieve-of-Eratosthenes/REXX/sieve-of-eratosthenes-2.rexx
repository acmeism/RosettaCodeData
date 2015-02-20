/*REXX pgm gens primes via a  wheeled  sieve of Eratosthenes  algorithm.*/
parse arg H .;   if H==''  then H=200  /*let the highest # be specified.*/
tell=h>0;     H=abs(H);    w=length(H) /*neg H suppresses prime listing.*/
if 2<=H & tell  then say right(1,w+20)'st prime   ───► '   right(2,w)
#= w<=H                                /*number of primes found so far. */
@.=.                                   /*assume all numbers are prime.  */
!=0                                    /*skips top part of sieve marking*/
    do j=3  by 2  for (H-2)%2          /*odd integers up to H inclusive.*/
    if @.j==''  then iterate           /*composite?  Then skip this num.*/
    #=#+1                              /*bump the prime number counter. */
    if tell     then say right(#,w+20)th(#)   'prime   ───► '   right(j,w)
    if !        then iterate           /*should the top part be skipped?*/
    jj=j*j                             /*compute the square of  J.   __ */
    if jj>H     then !=1               /*indicate skipping  if  j > √ H.*/
       do m=jj  to H by j+j; @.m=; end /*strike odd multiples as ¬ prime*/
    end   /*j*/                        /*       ───                     */
say
say  right(#,w+20)    'prime's(#)    "found."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines────────────────────────────────────────*/
s:  if arg(1)==1  then return arg(3);  return word(arg(2) 's',1)         /*pluralizer.*/
th: procedure; parse arg x; x=abs(x);  return word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
