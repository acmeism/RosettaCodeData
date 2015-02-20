/*REXX program tests for primality using (kinda smartish) trial division*/
parse arg n .;  if n==''  then n=10000 /*let user choose the upper limit*/
tell=(n>0);     n=abs(n)               /*display primes only if  N > 0  */
p=0                                    /*a count of primes  (so far).   */
      do j=-57  to n                   /*start in the cellar and work up*/
      if \isPrime(j)  then iterate     /*if not prime, then keep looking*/
      p=p+1                            /*bump the jelly bean counter.   */
      if tell  then say right(j,20) 'is prime.'  /*maybe show the prime.*/
      end   /*j*/
say
say   "There are "     p      " primes up to "      n      ' (inclusive).'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isPrime:  procedure;    parse arg x    /*get integer to be investigated.*/
if x<11     then return wordpos(x,'2 3 5 7')\==0    /*is it a wee prime?*/
if x//2==0  then return 0              /*eliminate all the even numbers.*/
if x//3==0  then return 0              /* ··· and eliminate the triples.*/

         do k=5  by 6  until k*k>x     /*this skips odd multiples of 3. */
         if x//k    ==0  then return 0 /*perform a divide (modulus),    */
         if x//(k+2)==0  then return 0 /* ··· and the next umpty one.   */
         end   /*k*/                   /*Note:  REXX   //   is remainder*/
return 1                               /*did all divisions, it's prime. */
