/*REXX pgm calculates the  air mass  above an observer and an object for various angles.*/
numeric digits (length(pi()) - length(.)) % 4    /*calculate the number of digits to use*/
parse arg aLO aHI aBY oHT .                      /*obtain optional arguments from the CL*/
if aLO=='' | aLO==","  then aLO=     0           /*not specified?  Then use the default.*/
if aHI=='' | aHI==","  then aHI=    90           /* "      "         "   "   "     "    */
if aBY=='' | aBY==","  then aBY=     5           /* "      "         "   "   "     "    */
if oHT=='' | oHT==","  then oHT= 13700           /* "      "         "   "   "     "    */
w= 30;             @ama= 'air mass at'           /*column width for the two air_masses. */
say 'angle|'center(@ama  "sea level", w)  center(@ama  commas(oHT)  'meters', w) /*title*/
say "─────┼"copies(center('', w, "─"), 2)'─'     /*display the title sep for the output.*/
y= left('', w-20)                                /*Y:  for alignment of the output cols.*/

      do j=aLO  to aHI  by aBY;        am0= airM(0, j);                 amht= airM(oHT, j)
      say center(j, 5)'│'right( format(am0, , 8), w-10)y  right( format(amht, , 8), w-10)y
      end   /*j*/

say "─────┴"copies(center('', w, "─"), 2)'─'     /*display the foot separator for output*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
airM: procedure; parse arg a,z;    if z==0  then return 1;  return colD(a, z) / colD(a, 0)
d2r:  return r2r( arg(1) * pi() / 180)           /*convert degrees   ──► radians.       */
pi:   pi= 3.1415926535897932384626433832795028841971693993751058209749445923078; return pi
rho:  procedure; parse arg a;            return exp(-a / 8500)
r2r:  return arg(1)  //  (pi() * 2)              /*normalize radians ──► a unit circle. */
e:    e= 2.718281828459045235360287471352662497757247093699959574966967627724;   return e
commas: parse arg ?; do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos:  procedure; parse arg x;    x= r2r(x);  a= abs(x);  numeric fuzz min(6, digits() - 3)
      hpi= pi*.5;  if a=pi    then return -1;   if a=hpi | a=hpi*3  then return 0;    z= 1
                   if a=pi/3  then return .5;   if a=pi*2/3         then return -.5;  _= 1
      x= x*x;  p= z;      do k=2  by 2;  _= -_ * x / (k*(k-1));     z= z + _
                          if z=p  then leave;   p= z;   end;                    return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
exp:  procedure; parse arg x;  ix= x%1;  if abs(x-ix)>.5  then ix= ix + sign(x);   x= x-ix
      z=1;  _=1;   w=z;     do j=1; _= _*x/j;  z=(z+_)/1;  if z==w  then leave;  w=z;  end
      if z\==0  then z= z * e() ** ix;                                          return z/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0;  d= digits();  numeric digits; h= d+6
      numeric form; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g= g * .5'e'_ % 2
      m.=9;     do j=0  while h>9;       m.j= h;               h= h%2 + 1;      end  /*j*/
                do k=j+5  to 0  by -1;   numeric digits m.k;   g= (g+x/g)*.5;   end  /*k*/
      numeric digits d;                  return g/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
elev: procedure; parse arg a,z,d;        earthRad= 6371000     /*earth radius in meters.*/
      aa= earthRad + a;  return sqrt(aa**2 + d**2 - 2*d*aa*cos( d2r(180-z) ) )  - earthRad
/*──────────────────────────────────────────────────────────────────────────────────────*/
colD: procedure; parse arg a,z;          sum= 0;   d= 0;    dd= .001;   infinity= 10000000
                   do while d<infinity;  delta= max(dd, dd*d)
                   sum= sum  +  rho( elev(a, z, d + 0.5*delta) ) * delta;     d= d + delta
                   end   /*while*/
      return sum
