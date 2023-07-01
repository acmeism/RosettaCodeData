/*REXX program computes and displays the Isqrt  (integer square root)  of some integers.*/
numeric digits 200                               /*insure 'nuff decimal digs for results*/
parse arg range power base .                     /*obtain optional arguments from the CL*/
if range=='' | range==","  then range= 0..65     /*Not specified?  Then use the default.*/
if power=='' | power==","  then power= 1..73     /* "      "         "   "   "     "    */
if base =='' | base ==","  then base =     7     /* "      "         "   "   "     "    */
parse var  range   rLO  '..'  rHI;     if rHI==''  then rHI= rLO      /*handle a range? */
parse var  power   pLO  '..'  pHI;     if pHI==''  then pHI= pLO      /*   "   "   "    */
$=
            do j=rLO  to rHI  while rHI>0        /*compute Isqrt for a range of integers*/
            $= $ commas( Isqrt(j) )              /*append the Isqrt to a list for output*/
            end   /*j*/
$= strip($)                                      /*elide the leading blank in the list. */
say center(' Isqrt for numbers: '   rLO   " ──► "  rHI' ',  length($),  "─")
say strip($)                                     /*$  has a leading blank for 1st number*/
say
z= base ** pHI                                   /*compute  max. exponentiation product.*/
Lp= max(30, length( commas(       z) ) )         /*length of "          "          "    */
Lr= max(20, length( commas( Isqrt(z) ) ) )       /* "     "    "  "   "  Isqrt of above.*/
say 'index'   center(base"**index", Lp)       center('Isqrt', Lr)        /*show a title.*/
say '─────'   copies("─",           Lp)       copies('─',     Lr)        /*  "  " header*/

            do j=pLO  to pHI  by 2  while pHI>0;                              x= base ** j
            say center(j, 5)  right( commas(x), Lp)      right( commas( Isqrt(x) ),  Lr)
            end   /*j*/                          /* [↑]  show a bunch of powers & Isqrt.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do jc=length(_)-3  to 1  by -3; _=insert(',', _, jc); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
Isqrt: procedure; parse arg x                    /*obtain the only passed argument  X.  */
       x= x % 1                                  /*convert possible real X to an integer*/     /* ◄■■■■■■■  optional. */
       q= 1                                      /*initialize the  Q  variable to unity.*/
                               do until q>x      /*find a  Q  that is greater than  X.  */
                               q= q * 4          /*multiply   Q   by four.              */
                               end   /*until*/
       r= 0                                      /*R:    will be the integer sqrt of X. */
                 do while q>1                    /*keep processing while  Q  is > than 1*/
                 q= q % 4                        /*divide  Q  by four  (no remainder).  */
                 t= x - r - q                    /*compute a temporary variable.        */
                 r= r % 2                        /*divide  R  by two   (no remainder).  */
                 if t >= 0  then do              /*if   T  is non─negative  ...         */
                                 x= t            /*recompute the value of  X            */
                                 r= r + q        /*    "      "    "    "  R            */
                                 end
                 end   /*while*/
       return r                                  /*return the integer square root of X. */
