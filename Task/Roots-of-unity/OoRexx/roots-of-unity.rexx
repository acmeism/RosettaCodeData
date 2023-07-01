/*REXX program computes the  K  roots of unity  (which include complex roots).*/
parse Version v
Say v
parse arg n frac .                     /*get optional arguments from the C.L. */
if n==''    then n=1                   /*Not specified?  Then use the default.*/
if frac=''  then frac=5                /* "      "         "   "   "     "    */
start=abs(n)                           /*assume only one  K  is wanted.       */
if n<0      then start=1               /*Negative?  Then use a range of  K's. */
                                       /*display unity roots for a range,  or */
  do k=start  to abs(n)                /*                   just for one  K.  */
  say right(k 'roots of unity',40,"-") /*display a pretty separator with title*/
     do angle=0  by 360/k  for k       /*compute the angle for each root.     */
     rp=adjust(rxCalcCos(angle,,'D'))  /*compute real part via  COS  function.*/
     if left(rp,1)\=='-' then rp=" "rp /*not negative?  Then pad with a blank.*/
     ip=adjust(rxCalcSin(angle,,'D'))  /*compute imaginary part via SIN funct.*/
     if left(ip,1)\=='-' then ip="+"ip /*Not negative?  Then pad with  + char.*/
     if ip=0  then say rp              /*Only real part? Ignore imaginary part*/
              else say left(rp,frac+4)ip'i'   /*show the real & imaginary part*/
     end  /*angle*/
  end      /*k*/
exit                                   /*stick a fork in it,  we're all done. */
/*----------------------------------------------------------------------------*/
adjust: parse arg x; near0='1e-' || (digits()-digits()%10)   /*compute small #*/
        if abs(x)<near0  then x=0            /*if near zero, then assume zero.*/
        return format(x,,frac)/1             /*fraction digits past dec point.*/
::requires rxMath library
