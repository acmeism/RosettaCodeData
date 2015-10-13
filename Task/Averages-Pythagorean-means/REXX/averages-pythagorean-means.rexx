/*REXX program to compute and display Pythagorean means [Amean, Gmean, Hmean].*/
parse arg n .                          /*obtain the optional argument from CL.*/
if n==''  then n=10                    /*None specified?  Then assume default.*/
sum=0                /*░░░░░░░░░░░░░░░░░░compute Amean [Arithmetic mean]░░░░░░*/
                     do a=1  for n     /*populate the array and calculate sum.*/
                     @.a=a             /*populate the stemmed array   @.      */
                     sum=sum + @.a     /*compute the sum of all the elements. */
                     end    /*a*/
Amean=sum/n                            /*calculate the arithmetic mean.       */
say 'Amean =' Amean                    /*display    "      "        "         */
prod=1               /*░░░░░░░░░░░░░░░░░░compute Gmean [Geometric mean]░░░░░░░*/
                     do g=1  for n
                     prod=prod * @.g   /*compute the product of all elements. */
                     end    /*g*/
Gmean=Iroot(prod,n)                    /*calculate the geometric mean.        */
say 'Gmean =' Gmean                    /*display    "      "       "          */
rsum=0               /*░░░░░░░░░░░░░░░░░░compute Hmean [Harmonic mean]░░░░░░░░*/
                     do r=1  for n
                     rsum=rsum + 1/@.r /*compute the sum of the reciprocals.  */
                     end    /*r*/
Hmean=n/rsum                           /*calculate the harmonic mean.         */
say 'Hmean =' Hmean                    /*display    "      "      "           */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Iroot: procedure; arg x 1 ox, y 1 oy   /*get both args, and also a copy of X&Y*/
if x=0 | x=1     then return x         /*handle special case of zero and unity*/
if y=0           then return 1         /*   "      "      "   " a   zero root.*/
if y=1           then return x         /*   "      "      "   " a  unity root.*/
if x<0 & y//2==0 then do               /*check for an illegal combination.    */
                      say;   say '*** error! *** (from Iroot):';   say
                      say 'root'   y   "can't be even if first argument is < 0."
                      say;   return '[n/a]'  /*return a "not applicable" text.*/
                      end
x=abs(x);  y=abs(y);         m=y-1     /*use the absolute value for  X and Y. */
digO=digits()                          /*save original accuracy (decimal digs)*/
a=digO+5                               /*use an extra five digs     "      "  */
g=(x+1)/y**y                           /*use this as the first guesstimate.   */
numeric fuzz 3                         /*use three fuzz digits for comparisons*/
d=5               /*Start with 5 digits accuracy.  When the digits is large,  */
                  /*CPU time is wasted when the guess isn't close to the root.*/

  do forever   /* ◄──────────────────┐   keep plugging as digits are increased*/
  d=min(d+d,a)                 /*    │   limit the digits to original digs+5. */
  numeric digits d             /*    │   keep increasing the accuracy.        */
  old=.                        /*    │   define the old (guess).              */
                               /*    │                                        */
    do forever   /* ◄─────────────┐  │   keep plugging at the   Yth   root.   */
    _=(m*g**y+x)/y/g**m        /* │  │   this is the nitty─gritty stuff.      */
    if _=g | _=old then leave  /* │  │   are we close enough yet ?            */
    old=g;   g=_               /* │  │   save guess to old);  set new guess.  */
    end   /*forever ►─────────────┘  │                                        */
                               /*    │                                        */
  if d==a then leave           /*    │   are we at the desired accuracy ?     */
  end     /*forever ►────────────────┘                                        */

_=g*sign(ox);  if oy<0  then _=1/_     /*adjust for original X sing; neg. root*/
numeric digits digO;    return _/1     /*normalize to original decimal digits.*/
