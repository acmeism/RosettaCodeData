/*REXX program to use Lucas-Lehmer primality test for prime powers of 2.*/
parse arg limit .                      /*get the argument (if any).     */
if limit=='' then limit=1000           /*if no argument, assume 1000.   */
list=                                  /*placeholder for the results.   */

  do j=1  by 2  to limit               /*only process so much...        */
                               /*there're only so many hours in a day...*/
  power=j
  if j==1  then power=2                /*special case for the even prime*/
  if \isprime(power ) then iterate     /*if not prime, then ignore it.  */
  list=list Lucas_Lehmer2(power)       /*add to list  (or maybe not).   */
  end   /*j*/

list=space(list)                       /*remove extraneous blanks.      */
say;    say center('list',60-3,"═")    /*show a fancy-dancy header/title*/
say
        do k=1 for words(list)         /*show entries in list,  1/line. */
        say right(word(list,k),30)     /*and right-justify 'em.         */
        end   /*k*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LUCAS_LEHMER2 subroutine────────────*/
Lucas_Lehmer2: procedure; parse arg ?  /*Lucas-Lehmer test on  2**? - 1 */
numeric form                           /*ensure correct scientific form.*/

if ?==2  then s=0
         else s=4
                  /* DIGITs of 1 million could be used, but that really */
                  /* slows up the whole works.  So, we start with the   */
                  /* default of 9 digits,  find the 10's exponent in    */
                  /* the product  (2**?),  double it,  and  then add 6. */
                  /* 2   is all that's needed,  but  6  is a lot safer. */
                  /* The doubling is for the square of  S  (s*s, below).*/

q=2**?            /*compute a power of 2,  using only 9 decimal digits. */

if pos('E',q)\==0  then do             /*is it in exponential notation? */
                        parse var q 'E' tenpow
                        numeric digits tenpow*2+6
                        end
                   else numeric digits digits()*2+6         /*  9*2 + 6 */

q=2**?-1                               /*now, compute the real McCoy.   */
            do ?-2                     /*apply, rinse, repeat ...       */
            s=(s*s-2) // q             /*modulus in REXX is:     //     */
            end

if s\==0  then return ''               /*return nuttin' if not prime.   */
say "Mersenne prime via Lucas Lehmer test:",
                      right('M'?,10) right("["digits() "digits]",25)
return 'M'?                            /*return modified (prime) number.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isprime:  procedure;  parse arg x
if x<17 then return wordpos(x,'2 3 5 7 11 13')\==0  /*test special cases*/
if       x//2==0  then return 0        /*is it even?          Not prime.*/
if       x//3==0  then return 0        /*divisible by three?  Not prime.*/
if right(x,1)==5  then return 0        /*divisible by three?  Not prime.*/
if       x//7==0  then return 0        /*divisible by seven?  Not prime.*/

  do j=11  by 6                        /*ensures J isn't divisible by 3.*/
  if x// j   ==0  then return 0
  if x//(j+2)==0  then return 0
  if j*j>x        then return 1        /*past the sqrt of X?  It's prime*/
  end   /*j*/
