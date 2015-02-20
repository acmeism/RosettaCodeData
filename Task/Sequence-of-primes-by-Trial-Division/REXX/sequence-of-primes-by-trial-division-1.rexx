/*REXX pgm lists a sequence of primes by testing primality by trial div.*/
parse arg n .                          /*let user choose how many, maybe*/
if n==''  then n=26                    /*if not, then assume the default*/
tell=n>0;      n=abs(n)                /*N is negative?   Don't display.*/
@.1=2;  if tell  then say right(@.1,9) /*display  2  as a special case. */
#=1                                    /*# is the number of primes found*/
                                       /* [↑]  N default lists up to 101*/
   do j=3  by 2  while  #<n            /*start with the first odd prime.*/
                                       /* [↓]  divide by the primes. ___*/
          do k=2  to #  while  !.k<=j  /*divide J with all primes ≤ √ J */
          if j//@.k==0  then iterate j /*÷ by a previous prime?  ¬prime.*/
          end   /*j*/                  /* [↑]   only divide up to  √J.  */
   #=#+1                               /*bump the prime number counter. */
   @.#=j;   !.#=j*j                    /*define this prime & its square.*/
   if tell  then say right(j, 9)       /*maybe display this prime──►term*/
   end     /*j*/                       /* [↑]  only display  N  primes. */
                                       /* [↓]  display the prime count. */
say  #   ' primes found.'              /*stick a fork in it, we're done.*/
