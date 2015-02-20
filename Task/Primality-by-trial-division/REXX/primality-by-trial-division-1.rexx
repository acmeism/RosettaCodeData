/*REXX program tests for primality using (kinda smartish) trial division*/
parse arg n .;  if n==''  then n=10000 /*let user choose the upper limit*/
tell=(n>0);     n=abs(n)               /*display primes only if  N > 0  */
p=0                                    /*a count of primes  (so far).   */
      do j=-57  to n                   /*start in the cellar and work up*/
      if \isPrime(j)  then iterate     /*if not prime, keep looking.    */
      p=p+1                            /*bump the jelly bean counter.   */
      if tell  then say right(j,20) 'is prime.'  /*maybe show the prime.*/
      end   /*j*/
say
say   "There are "     p      " primes up to "      n      ' (inclusive).'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isPrime:  procedure;         parse arg x    /*get the number in question*/
if wordpos(x,'2 3 5 7')\==0  then return 1  /*is number a teacher's pet?*/
if x<2 | x//2==0 | x//3==0   then return 0  /*weed out the riff-raff.   */

   do k=5  by  6  until k*k>x               /*skips odd multiples of 3. */
   if x//k==0 | x//(k+2)==0  then return 0  /*a pair of divides.     ___*/
   end   /*k*/                              /*divide up through the √ x.*/
                                            /*Note:   //   is remainder.*/
return 1                                    /*done dividing, it's prime.*/
