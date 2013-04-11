/*REXX program tests for primality using (kinda smartish) trial division*/
parse arg n .                          /*let user choose how many, maybe*/
if n=='' then n=10000                  /*if not, then assume the default*/
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
if x<107 then do                        /*test for (low) special cases. */
              _='2 3 5 7 11 13 17 19 23 29 31 37 41 43 47', /*list of ··*/
                '53 59 61 67 71 73 79 83 89 97 101 103'     /*wee primes*/
              return wordpos(x,_)\==0   /*is it a wee prime? ··· or not?*/
              end

if       x// 2 ==0  then return 0      /*eliminate the evens.           */
if       x// 3 ==0  then return 0      /* ··· and eliminate the triples.*/
if right(x,1) == 5  then return 0      /* ··· and eliminate the nickels.*/
if       x// 7 ==0  then return 0      /* ··· and eliminate the luckies.*/
if       x//11 ==0  then return 0
if       x//13 ==0  then return 0
if       x//17 ==0  then return 0
if       x//19 ==0  then return 0
if       x//23 ==0  then return 0
if       x//29 ==0  then return 0
if       x//31 ==0  then return 0
if       x//37 ==0  then return 0
if       x//41 ==0  then return 0
if       x//43 ==0  then return 0
if       x//47 ==0  then return 0
if       x//53 ==0  then return 0
if       x//59 ==0  then return 0
if       x//61 ==0  then return 0
if       x//67 ==0  then return 0
if       x//71 ==0  then return 0
if       x//73 ==0  then return 0
if       x//79 ==0  then return 0
if       x//83 ==0  then return 0
if       x//89 ==0  then return 0
if       x//97 ==0  then return 0
if       x//101==0  then return 0
if       x//103==0  then return 0
                                       /*Note:      //     is modulus.  */
   do k=107  by 6  while k*k<=x        /*this skips odd multiples of 3. */
   if x // k     == 0   then return 0  /*perform a divide (modulus),    */
   if x // (k+2) == 0   then return 0  /* ··· and the next umpty one.   */
   end   /*k*/

return 1                               /*after all that, ··· it's prime.*/
