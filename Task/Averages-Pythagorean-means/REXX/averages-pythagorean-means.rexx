/*REXX program to compute/show Pythagorean means  [Amean, Gmean, Hmean].*/
parse arg n .                          /*maybe get an optional argument.*/
if n==''  then n=10                    /*None specified?  Assume default*/
                     /*══════════════════compute Amean [Arithmetic mean]*/
sum=0;               do j=1  for n
                     @.j=j             /*populate the stemmed array  @. */
                     sum=sum+@.j       /*compute the sum of all elements*/
                     end    /*j*/
Amean=sum/n                            /*calculate the Amean.           */
say 'Amean =' Amean                    /*show and tell Amean.           */
                     /*══════════════════compute Gmean [Geometric mean].*/
prod=1;              do k=1  for n
                     prod=prod*@.k     /*comp. product of all elements. */
                     end    /*k*/
Gmean=iroot(prod,n)                    /*calculate the Gmean.           */
say 'Gmean =' Gmean                    /*show and tell Gmean.           */
                     /*══════════════════compute Hmean [Harmonic mean]. */
rsum=0;              do m=1  for n
                     rsum=rsum+1/@.m   /*compute the sum of reciprocals.*/
                     end    /*m*/
Hmean=n/rsum                           /*calculate the Hmean.           */
say 'Hmean =' Hmean                    /*show and tell Hmean.           */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────IROOT subroutine────────────────────*/
iroot: procedure; arg x 1 ox,y 1 oy    /*get both args, and also a copy.*/
if x=0 | x=1  then return x            /*handle special case of 0 & 1.  */
if y=0  then return 1                  /*handle special case of root 0. */
if y=1  then return x                  /*handle special case of root 1. */
if x<0 & y//2==0 then do               /*check for illegal combination. */
                      say;   say '*** error! *** (from IROOT):';   say
                      say 'root' y "can't be even if 1st argument is < 0."
                      say;   return '[n/a]'  /*return a  not applicable.*/
                      end
x=abs(x)                               /*use the absolute value for X.  */
y=abs(y)                               /*use the absolute value for root*/
digO=digits()                          /*save original accuracy (digits)*/
a=digO+5                               /*use an extra 5 digs (accuracy).*/
g=(x+1)/y**y                           /*use this as the 1st guesstimate*/
m=y-1                                  /*use this as a fast   [root-1]. */
numeric fuzz 3                         /*3 fuzz digits for comparisons. */
d=5                           /*start with 5 digits accuracy.  When the */
                              /*DIGITS is large, CPU time is wasted on  */
                              /*large accuracies when the  guess  isn't */
                              /*close to the final answer.  It's best to*/
                              /*take baby steps before going full bore  */
                              /*throttle and putting the pedal to the   */
                              /*metal,  getting it in high gear,  and   */
                              /*then turning the volume all the way up. */

  do forever   /* ◄─────────────────┐    keep plugging as digs increases*/
  d=min(d+d,a)                /*    │    limit the digits to orig digs+5*/
  numeric digits d            /*    │    keep increasing the accuracy.  */
  old=0                       /*    │    define  old (guess).           */
                              /*    │                                   */
    do forever   /* ◄────────────┐  │    keep plugging at the  Yth root.*/
    _=(m*g**y+x)/y/g**m       /* │  │    this is the nitty-gritty stuff.*/
    if _=g | _=old then leave /* │  │    are we close enough yet ?      */
    old=g                     /* │  │    save guess in old (guess).     */
    g=_                       /* │  │    set Guess to what's been calc. */
    end   /*forever ►────────────┘  │                                   */
                              /*    │                                   */
  if d==a then leave          /*    │    are we at the desired accuracy?*/
  end     /*forever ►───────────────┘                                   */

_=g*sign(ox)                           /*adjust for the sign of orig X. */
if oy<0  then _=1/_                    /*adjust for negative root.      */
numeric digits digO                    /*restore the original digits.   */
return _/1                             /*normalize result to orig digits*/
