/*REXX pgm shows:  hour,  sun hour angle,  dial hour line angle,  6am ───► 6pm*/
numeric digits 60                     /*better overkill then underkill for dig*/

parse arg lat lng mer .               /*get the optional arguments from the CL*/
                          /*None specified?   Then use the default of Jules   */
                          /*Verne's Lincoln Island,  aka  Ernest Legouve Reef.*/

if lat=='' | lat==',' then lat=-4.95  /*Not specified?   Then use the default.*/
if lng=='' | lng==',' then lng=-150.5 /* "      "          "   "   "     "    */
if mer=='' | mer==',' then mer=-150   /* "      "          "   "   "     "    */
L=max(length(lat), length(lng), length(mer))
      say '       latitude:'    right(lat,L)
      say '      longitude:'    right(lng,L)
      say ' legal meridian:'    right(mer,L)
sineLat=sin(d2r(lat))
w1=max(length('hour')     ,length('midnight'))+2
w2=max(length('sun hour') ,length('angle'))+2
w3=max(length('dial hour'),length('line angle'))+2
indent=left('',30)                     /*make the presentation prettier.      */
say indent  center('    ',w1)   center('sun hour',w2)    center('dial hour' ,w3)
say indent  center('hour',w1)   center('angle'   ,w2)    center('line angle',w3)
call sep                               /*add a separator line for the eyeballs*/

      do h=-6  to 6                    /*Okey dokey then, let's get busy.     */
           select
           when abs(h)==12  then hc='midnight'     /*above the arctic circle? */
           when h<0  then hc=-h 'am'   /*convert the hour for human beans.    */
           when h==0 then hc='noon'    /*  ... easier to understand now.      */
           when h>0  then hc=h 'pm'    /*  ... even more meaningful.          */
           end   /*select*/
      hra=15*h-lng+mer
      hla=r2d(Atan(sineLat*tan(d2r(hra))))
      say indent center(hc,w1) right(format(hra,,1),w2) right(format(hla,,1),w3)
      end        /*h*/

call sep
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────subroutines───────────────────────────────*/
sep:  say indent  copies('═',w1)  copies('═',w2)  copies('═',w3);     return
d2d:  return arg(1)         // 360     /*normalize degrees ──► a unit circle. */
d2r:  return r2r(arg(1)*pi() / 180)    /*convert degrees   ──► radians.       */
r2d:  return d2d((arg(1)*180 / pi()))  /*convert radians   ──► degrees.       */
r2r:  return arg(1)         //(pi()*2) /*normalize radians ──► a unit circle. */
tan:  procedure; parse arg x; _=cos(x); if _=0 then call tanErr; return sin(x)/_
tanErr:  call tellErr 'tan(' || x") causes division by zero, X=" || x
tellErr: say; say '*** error! ***'; say; say arg(1); say; exit 13
AsinErr: call tellErr 'Asin(x),  X  must be in the range of  -1 ──► +1,  X=' ||x
sqrtErr: call tellErr "sqrt(x),  X  can't be negative,  X="      || x
AcosErr: call tellErr 'Acos(x),  X  must be in the range of  -1 ──► +1,  X=' ||x
Acos: procedure; arg x;  if x<-1|x>1  then call AcosErr;  return .5*pi()-Asin(x)

Atan: procedure; arg x;  if abs(x)=1  then return pi()/4*sign(x)
                                           return Asin(x/sqrt(1+x**2))

sin:  procedure; arg x;  x=r2r(x);  numeric fuzz min(5,digits()-3)
                 if abs(x)=pi()  then return 0;       return .sinCos(x,x,1)

cos:  procedure; parse arg x;       x=r2r(x);            a=abs(x);     hpi=pi*.5
                 numeric fuzz min(6,digits()-3);      if a=pi()   then return -1
                 if a=hpi | a=hpi*3  then return 0;   if a=pi()/3 then return .5
                 if a=pi()*2/3       then return -.5;     return .sinCos(1,1,-1)

.sinCos: parse arg z,_,i;  x=x*x;  p=z
      do k=2 by 2; _=-_*x/(k*(k+i));z=z+_; if z=p then leave; p=z; end; return z

Asin: procedure;  parse arg x;  if x<-1 | x>1  then call AsinErr;    s=x*x
      if abs(x)>=.7 then return sign(x)*Acos(sqrt(1-s));  z=x;  o=x;  p=z
      do j=2 by 2; o=o*s*(j-1)/j; z=z+o/(j+1); if z=p then leave; p=z; end
      return z

pi: pi=,                               /*a bit of an overkill,  but hey !!    */
  3.1415926535897932384626433832795028841971693993751058209749445923078164062862
  return pi      /*Note:  the real  PI  subroutine returns PI's accuracy that */
                 /*matches the current NUMERIC DIGITS, up to 1 million digits.*/
                 /*John Machin's formula is used for calculating more digits. */

sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
