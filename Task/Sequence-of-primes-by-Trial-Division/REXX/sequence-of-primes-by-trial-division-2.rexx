/*REXX pgm lists a sequence of primes by testing  primality by trial division.*/
parse arg n .                          /*get optional number of primes to find*/
if n==''  then n=26                    /*Not specified?   Then assume default.*/
tell=n>0;      n=abs(n)                /*N is negative?   Then don't display. */
@.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13;  #=5;   s=@.#+2
                                       /*   [↑]  is the number of low primes. */
      do p=1  for #  while  p<=n       /* [↓]  find primes, but don't show 'em*/
      if tell  then say right(@.p,9)   /*display some pre-defined low primes. */
      !.p=@.p**2                       /*also compute the squared value of P. */
      end   /*p*/                      /* [↑]  allows faster loop (below).    */
                                       /* [↓]  N:  default lists up to 101 #s.*/
   do j=s  by 2  while  #<n            /*start with the next odd prime.       */
   if j//  3    ==0   then iterate     /*is this number a triple?             */
   parse var j '' -1 _                 /*obtain the last digit of the  J  var.*/
   if _         ==5   then iterate     /*is this number a nickel?             */
   if j//  7    ==0   then iterate     /* "   "     "     lucky?              */
   if j// 11    ==0   then iterate     /* "   "     "  a multiple of 11?      */
                                       /* [↓]  divide by the primes.   ___    */
          do k=p  to #  while  !.k<=j  /*divide  J  by other primes ≤ √ J     */
          if j//@.k==0  then iterate j /*+ by prev. prime?  ¬prime     ___    */
          end   /*j*/                  /* [↑]   only divide up to     √ J     */
   #=#+1                               /*bump the counter of number of primes.*/
   @.#=j;   !.#=j*j                    /*define this prime; define its square.*/
   if tell  then say right(j, 9)       /*maybe display this prime ──► terminal*/
   end     /*j*/                       /* [↑]  only display N number of primes*/
                                       /* [↓]  display number of primes found.*/
say  #   ' primes found.'              /*stick a fork in it,  we're all done. */
