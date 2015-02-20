/*REXX program to use Lucas-Lehmer primality test for prime powers of 2.*/
parse arg limit .                      /*get the optional arg from C.L. */
if limit==''  then limit=1000          /*No argument?  Then assume 1000.*/
list=                                  /*placeholder for the results.   */
                                       /* [↓]  only process up to LIMIT,*/
  do j=1  by 2  to limit               /*···only so many hours in a day.*/
  power=j + (j==1)                     /*POWER ≡ J  except for when J=1.*/
  if \isPrime(power)  then iterate     /*if not prime, then ignore it.  */
  list=list Lucas_Lehmer2(power)       /*add to list  (···or maybe not).*/
  end   /*j*/

list=space(list)                       /*remove all extraneous blanks.  */
say;    say center('list',60-3,"═")    /*show a fancy-dancy header/title*/
say
        do k=1  for words(list)        /*show entries in list,  1/line. */
        say right(word(list,k),30)     /*right-justify 'em to look nice.*/
        end   /*k*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isPrime: procedure;  parse arg x                    /*get # to be tested*/
if x<17  then return wordpos(x,'2 3 5 7 11 13')\==0 /*test special cases*/
if       x//2==0  then return 0        /*is it even?          Not prime.*/
if       x//3==0  then return 0        /*divisible by three?  Not prime.*/
if right(x,1)==5  then return 0        /*right-most dig ≡ 5?  Not prime.*/
if       x//7==0  then return 0        /*divisible by seven?  Not prime.*/

         do j=11  by 6   until j*j>x   /*ensures J isn't divisible by 3.*/
         if x// j   ==0  then return 0 /*is divisible by  J   ?         */
         if x//(j+2)==0  then return 0 /* "     "      "  J+2 ?      ___*/
         end   /*j*/                   /* [↑]  perform loop through √ x */
return 1                               /*indicate the number X is prime.*/
/*──────────────────────────────────LUCAS_LEHMER2 subroutine────────────*/
Lucas_Lehmer2: procedure; parse arg ?  /*Lucas-Lehmer test on  2**? - 1 */
if form()\=='SCIENTIFIC'  then numeric form     /*ensure correct # form.*/
if ?==2  then s=0                      /*handle the special  even  case.*/
         else s=4
q=2**? /*╔═════════════════════════════════════════════════════════════╗
         ║Compute a power of 2,  using only 9 decimal digits.   DIGITs ║
         ║of 1 million could be used, but that really gums up the whole║
         ║works.  So, we start with the default of 9 digits,  find the ║
         ║ten's exponent in the product (2**?), double it, and then add║
         ║6.       2   is all that's needed,  but   6   is a lot safer.║
         ║The doubling is for the squaring of    S    (below, for s*s).║
         ╚═════════════════════════════════════════════════════════════╝*/
if pos('E',q)\==0  then do             /*is  #  in exponential notation?*/
                        parse var q 'E' tenpow
                        numeric digits tenpow*2 + 6
                        end
                   else numeric digits digits()*2 + 6        /* 9*2 + 6 */
q=2**?-1
            do ?-2                     /*apply, rinse, repeat ···       */
            s=(s*s-2) // q             /*remainder in REXX is:    //    */
            end                        /* [↑]   compute the real McCoy. */

if s\==0  then return ''               /*return nuttin' if not prime.   */
               return 'M'?             /*return modified (prime) number.*/
