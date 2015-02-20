/*REXX program generates primes via the sieve of Eratosthenes algorithm.*/
parse arg H .;   if H==''  then H=200  /*was the high limit specified?  */
w=length(H);  @prime=right('prime',20) /*W is used for formatting output*/
@.=.                                   /*assume all numbers are prime.  */
#=0                                    /*number of primes found so far. */
    do j=2  for H-1                    /*all integers up to H inclusive.*/
    if @.j==''  then iterate           /*Composite?  Then skip this num.*/
    #=#+1                              /*bump the prime number counter. */
    say  @prime right(#,w)    " ───► " right(j,w)      /*show the prime.*/
      do m=j*j  to H  by j;  @.m=; end /*strike all multiples as ¬ prime*/
    end   /*j*/                        /*       ───                     */
                                       /*stick a fork in it, we're done.*/
say; say  right(#,w+length(@prime)+1)   'primes found.'
