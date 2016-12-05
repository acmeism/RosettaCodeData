/*REXX program lists a  sequence of primes  by  testing  primality  by  trial division. */
parse arg n .                                    /*get optional number of primes to find*/
if n=='' | n==","  then n=26                     /*Not specified?  Then use the default.*/
tell= (n>0);            n=abs(n)                 /*Is  N  negative?  Then don't display.*/
@.1=2;  if tell  then say right(@.1, 9)          /*display  2  as a special prime case. */
#=1                                              /*#  is number of primes found (so far)*/
                                                 /* [↑]  N:  default lists up to 101 #s.*/
   do j=3  by 2  while  #<n                      /*start with the first odd prime.      */
                                                 /* [↓]  divide by the primes.   ___    */
          do k=2  to #  while  !.k<=j            /*divide  J  with all primes ≤ √ J     */
          if j//@.k==0  then iterate j           /*÷ by prev. prime?  ¬prime     ___    */
          end   /*j*/                            /* [↑]   only divide up to     √ J     */
   #=#+1                                         /*bump the count of number of primes.  */
   @.#=j;   !.#=j*j                              /*define this prime; define its square.*/
   if tell  then say right(j, 9)                 /*maybe display this prime ──► terminal*/
   end   /*j*/                                   /* [↑]  only display N number of primes*/
                                                 /* [↓]  display number of primes found.*/
say  #       ' primes found.'                    /*stick a fork in it,  we're all done. */
