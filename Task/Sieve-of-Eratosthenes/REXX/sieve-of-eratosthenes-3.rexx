/*REXX pgm gens primes via a  wheeled  sieve of Eratosthenes  algorithm.*/
parse arg H .;    if H==''  then H=200 /*high# can be specified on C.L. */
w=length(H); @prime=right('prime', 20) /*W is used for formatting output*/
if 2<=H  then  say  @prime  right(1,w)     " ───► "    right(2,w)
#= 2<=H                                /*number of primes found so far. */
@.=.                                   /*assume all numbers are prime.  */
!=0                                    /*skips top part of sieve marking*/
    do j=3  by 2  for (H-2)%2          /*odd integers up to H inclusive.*/
    if @.j==''  then iterate           /*composite?  Then skip this num.*/
    #=#+1                              /*bump the prime number counter. */
    say  @prime right(#,w)    " ───► " right(j,w)      /*show the prime.*/
    if !        then iterate           /*should the top part be skipped?*/
    jj=j*j                             /*compute the square of  J.   __ */
    if jj>H     then !=1               /*indicate skipping  if  j > √ H.*/
       do m=jj  to H by j+j; @.m=; end /*strike odd multiples as ¬ prime*/
    end   /*j*/                        /*       ───                     */
say                                    /*stick a fork in it, we're done.*/
say  right(#, w+length(@prime)+1)  'primes found.'
