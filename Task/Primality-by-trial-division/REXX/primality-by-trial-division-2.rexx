/*REXX program tests for primality using (kinda smartish) trial division*/
parse arg n .                          /*let user choose how many, maybe*/
if n==''  then n=10000                 /*if not, then assume the default*/
p=0                                    /*a count of primes  (so far).   */
      do j=-57  to n                   /*start in the cellar and work up*/
      if \isprime(j)  then iterate     /*if not prime, then keep looking*/
      p=p+1                            /*bump the jelly bean counter.   */
      if j<99 then say right(j,20) 'is prime.'   /*Just show wee primes.*/
      end   /*j*/

say;        say   "There are"   p   "primes up to"   n   '(inclusive).'
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isprime:  procedure;    parse arg x    /*get integer to be investigated.*/
if \datatype(x,'W')  then return 0     /*X isn't an integer?  Not prime.*/
if x<11     then return wordpos(x,'2 3 5 7')\==0   /*is it a wee prime? */
if x//2==0  then return 0              /*eliminate the evens.           */
if x//3==0  then return 0              /* ··· and eliminate the triples.*/
                                       /*right dig test: faster than //.*/
   do k=5  by 6  until k*k > x         /*this skips odd multiples of 3. */
   if x // k     == 0   then return 0  /*perform a divide (modulus),    */
   if x // (k+2) == 0   then return 0  /* ··· and the next umpty one.   */
   end   /*k*/
                                       /*Note:      //     is modulus.  */
return 1                               /*did all divisions, it's prime. *//
