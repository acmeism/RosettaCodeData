/*REXX program tests for primality using (kinda smartish) trial division*/
parse arg n .                          /*let user choose how many, maybe*/
if n=='' then n=10000                  /*if not, then assume the default*/
p=0                                    /*a count of primes  (so far).   */
      do j=-57  to n                   /*start in the cellar and work up*/
      if \isprime(j)  then iterate     /*if not prime, keep looking.    */
      p=p+1                            /*bump the jelly bean counter.   */
      if j<99 then say right(j,20) 'is prime.'   /*Just show wee primes.*/
      end   /*j*/
say
say   "There are"   p   "primes up to"   n   '(inclusive).'
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isprime:  procedure;         parse arg x    /*get the number in question*/
if \datatype(x,'W')  then return 0          /*X not an integer?  ¬prime.*/
if wordpos(x,'2 3 5 7')\==0  then return 1  /*is number a teacher's pet?*/
if x<2 | x//2==0 | x//3==0   then return 0  /*weed out the riff-raff.   */

   do k=5  by  6  until k*k > x             /*skips odd multiples of 3. */
   if x//k==0 | x//(k+2)==0  then return 0  /*do a pair of divides (mod)*/
   end   /*k*/
                                            /*Note:   //  is modulus.   */
return 1                                    /*done dividing, it's prime.*/
