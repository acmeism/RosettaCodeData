/*REXX program to compute the   K   roots  of  unity.                   */
parse arg n frac .                     /*get the argument(s)  (if any). */
if n==''    then n=1                   /*no argument given?   Use one.  */
start=abs(n)                           /*assume only one  K  is wanted. */
if n<0      then start=1               /*Negative?  Use a range of K's. */
if frac=''  then frac=5                /*No frac?  Use default of 5 digs*/
numeric digits 60                      /*use sixty digits of precision. */
pi=pi()                                /*compute  π  to sixty digits.   */
                                       /*display unity roots for a ...  */
  do k=start  to abs(n)                /* ... range or just for one  K. */
  say right(k 'roots of unity',40,"─") /*display a pretty separator.    */

     do angle=0  by 2*pi/k  for k      /*compute angle for each root.   */
     rp=cos(angle)                     /*compute real part via COS func.*/
     rp=adjust(rp)                     /*adjust Rpart by limiting digs. */
     if left(rp,1)\=='-' then rp=' 'rp /*not negative?  Pad with blank. */

     ip=sin(angle)                     /*compute imag part via SIN func.*/
     ip=adjust(ip)                     /*adjust Ipart by limiting digs. */
     if left(ip,1)\=='-' then ip='+'ip /*not negative?  Pad with + char.*/

     if ip=0  then say rp              /*only real part?  Ignore IMAG.  */
              else say left(rp,frac+4)ip'i'   /*show real and imag part.*/

     end  /*angle*/
  end      /*k*/

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ADJUST subroutine───────────────────*/
adjust: arg x; near0='1e-'||(digits()-digits()%10)   /*compute small #. */
if abs(x)<near0 then x=0               /*if near zero, then assume zero.*/
return format(x,,frac)/1               /*"frac"  digits past dec point. */
/*──────────────────────────────────PI subroutine───────────────────────*/
pi: return ,                           /*100 digits of π                */
3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117068
/*──────────────────────────────────R2R subroutine──────────────────────*/
r2r: return arg(1) // (2*pi())         /*# radians to -360   > +360 deg.*/
/*──────────────────────────────────COS subroutine──────────────────────*/
cos: procedure; arg x; x=r2r(x); a=abs(x); numeric fuzz min(9,digits()-9);
if a=pi() then return -1; if a=pi()/2 | a=2*pi() then return 0
if a=pi()/3 then return .5; if a=2*pi()/3 then return -.5; return .sincos(1,1,-1)
/*──────────────────────────────────SIN subroutine──────────────────────*/
sin: procedure; arg x; x=r2r(x); numeric fuzz min(5,digits()-3)
if abs(x)=pi() then return 0; return .sincos(x,x,1)
/*──────────────────────────────────.SINCOS subroutine──────────────────*/
.sincos: parse arg z,_,i; x=x*x; p=z
  do k=2 by 2; _=-_*x/(k*(k+i)); z=z+_; if z=p then leave; p=z; end;
return z
