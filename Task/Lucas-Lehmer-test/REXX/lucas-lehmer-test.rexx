/*REXX program uses the  Lucas─Lehmer primality  test for prime powers of two.*/
trace i
parse arg limit .                      /*get optional arguments from the C.L. */
if limit==''  then limit=1000          /*No argument?  Then assume the default*/
list=                                  /*placeholder for the results.         */
                                       /* [↓]  only process up to the  LIMIT, */
  do j=1  by 2  to limit               /*there're only so many hours in a day.*/
  power=j + (j==1)                     /*POWER ≡ J    except   for when  J=1. */
  if \isPrime(power)  then iterate     /*if POWER isn't prime, then ignore it.*/
  $=Lucas_Lehmer2(power)               /*did it pass the Lucas─Lehmer2 test?  */
  if $\==''  then list=list $          /*Did the # pass? Then add to the list.*/
  end   /*j*/

list=space(list)                       /*elide all extraneous blanks from list*/
say;    say center('list',60-3,"═")    /*show a fancy─dancy header (title).   */
say
        do k=1  for words(list)        /*show entries in list,  one per line. */
        say right(word(list,k),30)     /*right─justify 'em to look pretty&nice*/
        end   /*k*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────ISPRIME subroutine────────────────────────*/
isPrime: procedure;  parse arg x                    /*get number to be tested.*/
if x<17  then return wordpos(x,'2 3 5 7 11 13')\==0 /*test for special cases. */
if       x//2==0  then return 0        /*is it even?           Then not prime.*/
if       x//3==0  then return 0        /*divisible by three?     "   "    "   */
if right(x,1)==5  then return 0        /*right-most dig ≡ 5?     "   "    "   */
if       x//7==0  then return 0        /*divisible by seven?     "   "    "   */

         do j=11  by 6   until j*j>x   /*ensures that J isn't divisible by 3. */
         if x// j   ==0  then return 0 /*is it divisible by  J   ?            */
         if x//(j+2)==0  then return 0 /* "  "     "      "  J+2 ?    ___     */
         end   /*j*/                   /* [↑]  perform loop through  √ x      */
return 1                               /*indicate the number  X  is prime.    */
/*──────────────────────────────────LUCAS_LEHMER2 subroutine──────────────────*/
Lucas_Lehmer2: procedure; parse arg ?  /*Lucas─Lehmer test on  2**? - 1       */
numeric form                           /*ensure the correct REXX number form. */
if ?==2  then s=0                      /*handle special case for an even prime*/
         else s=4
q=2**?     /*╔═══════════════════════════════════════════════════════════════╗
             ║ Compute a power of two,  using only 9 decimal digits.  DIGITs ║
             ║ of 1 million could be used, but that really gums up the whole ║
             ║ works.   So, we start with the default of 9 digits,  find the ║
             ║ ten's exponent in the product (2**?), double it, and then add ║
             ║ 6.       2   is all that's needed,  but   6   is a lot safer. ║
             ║ The doubling is for the squaring of    S    (below, for s*s). ║
             ╚═══════════════════════════════════════════════════════════════╝*/
if pos('E',q)\==0  then do             /*the number in exponential notation?  */
                        parse var q 'E' tenpow
                        numeric digits tenpow*2 + 6
                        end
                   else numeric digits digits()*2 + 6        /* 9*2 + 6 */
q=2**?-1
            do ?-2                     /*apply,  rinse,  repeat  ···          */
            s=(s*s-2) // q             /*remainder in REXX is:    //          */
            end                        /* [↑]   compute the real McCoy.       */

if s\==0  then return ''               /*return nuttin' if number isn't prime.*/
               return 'M'?             /*return a "modified" (prime) number.  */
