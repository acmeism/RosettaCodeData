/*REXX program computes the  K  roots of  unity  (which usually includes complex roots).*/
numeric digits length( pi() )  -  length(.)      /*use number of decimal digits in  pi. */
parse arg n frac .                               /*get optional arguments from the C.L. */
if   n=='' |    n==","  then     n= 1            /*Not specified?  Then use the default.*/
if frac='' | frac==","  then  frac= 5            /* "      "         "   "   "     "    */
                             start= abs(n)       /*assume only one  K  is wanted.       */
if n<0                  then start= 1            /*Negative?  Then use a range of  K's. */
      do #=start  to abs(n)                      /*show unity roots  (for a range or 1).*/
      say right(# 'roots of unity', 40, "─") ' (showing' frac "fractional decimal digits)"
         do angle=0  by pi*2/#  for #            /*compute the angle for each root.     */
         Rp= adj( cos(angle) )                   /*the    real   part via COS  function.*/
         Ip= adj( sin(angle) )                   /* "  imaginary   "   "  SIN      "    */
         if Rp>=0  then Rp= ' 'Rp                /*Not neg?  Then pad with a blank char.*/
         if Ip>=0  then Ip= '+'Ip                /* "   "      "   "    "  "  plus   "  */
         if Ip =0  then say Rp                   /*Only real part? Ignore imaginary part*/
                   else say left(Rp,frac+4)Ip'i' /*display the real and imaginary part. */
         end  /*angle*/
      end     /*#*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
adj: parse arg x; if abs(x) < ('1e-')(digits()*9%10)  then x= 0;  return format(x,,frac)/1
pi:  pi=3.141592653589793238462643383279502884197169399375105820974944592307816; return pi
r2r: pi2= pi() + pi;     return arg(1)  //  pi2  /*reduce #radians: -2pi ─► +2pi radians*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos: procedure; parse arg x;   x= r2r(x);   a= abs(x);   numeric fuzz min(9, digits() - 9)
     pi1_3=pi/3;      if a=pi1_3  then return .5;        if a=pi*.5 | a=pi2  then return 0
     if a=pi  then return -1;  if a=pi1_3*2  then return -.5;   z= 1;  _= 1;     $x= x * x
       do k=2  by 2  until p=z;  p=z;  _= -_ * $x / (k*(k-1));  z= z + _;  end;  return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
sin: procedure; parse arg x;   x= r2r(x);                numeric fuzz min(5, digits() - 3)
     if abs(x)=pi  then return 0;              $x= x * x;       z= x;  _= x
       do k=2  by 2  until p=z;  p=z;  _= -_ * $x / (k*(k+1));  z= z + _;  end;   return z
