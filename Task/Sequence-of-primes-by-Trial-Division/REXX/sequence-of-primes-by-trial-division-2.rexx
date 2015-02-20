/*REXX pgm lists a sequence of primes by testing primality by trial div.*/
parse arg n .                          /*let user choose how many, maybe*/
if n==''  then n=26                    /*if not, then assume the default*/
tell=n>0;      n=abs(n)                /*N is negative?   Don't display.*/
@.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13;  #=5;   s=@.#+2
                                       /*   [↑]  is the # of low primes.*/
      do p=1  for #  while  p<=n       /* [↓]  don't compute, just list.*/
      if tell  then say right(@.p,9)   /*display some low primes.       */
      !.p=@.p**2                       /*also compute the squared value.*/
      end   /*p*/                      /* [↑]  allows faster loop below.*/
                                       /* [↓]  N default lists up to 101*/
   do j=s  by 2  while  #<n            /*start with the next odd prime. */
   if j//  3    ==0   then iterate     /*is this number a triple?       */
   if right(j,1)==5   then iterate     /* "   "     "   " nickel?       */
   if j//  7    ==0   then iterate     /* "   "     "     lucky?        */
   if j// 11    ==0   then iterate     /* "   "     "  a multiple of 11?*/
                                       /* [↓]  divide by the primes. ___*/
          do k=p  to #  while  !.k<=j  /*divide J by other primes ≤ √ J */
          if j//@.k==0  then iterate j /*÷ by a previous prime?  ¬prime.*/
          end   /*j*/                  /* [↑]   only divide up to  √J.  */
   #=#+1                               /*bump the prime number counter. */
   @.#=j;   !.#=j*j                    /*define this prime & its square.*/
   if tell  then say right(j, 9)       /*maybe display this prime──►term*/
   end     /*j*/                       /* [↑]  only display  N  primes. */
                                       /* [↓]  display the prime count. */
say  #   ' primes found.'              /*stick a fork in it, we're done.*/
