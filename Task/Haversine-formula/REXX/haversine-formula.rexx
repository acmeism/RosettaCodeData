/*REXX pgm calculates distance between Nashville & Los Angles airports. */
say " Nashville:  north 36º  7.2', west  86º 40.2'   =   36.12º,  -86.67º"
say "Los Angles:  north 33º 56.4', west 118º 24.0'   =   33.94º, -118.40º"
say
$.=                                    /*set defaults for subroutines.  */
dist=surfaceDistance(36.12,  -86.67,  33.94,  -118.4)
kdist=format(dist/1       ,,2)         /*show 2 digs past decimal point.*/
mdist=format(dist/1.609344,,2)         /*  "  "   "    "     "      "   */
ndist=format(mdist*5280/6076.1,,2)     /*  "  "   "    "     "      "   */
say ' distance between=  '  kdist  " kilometers,"
say '               or   '  mdist  " statute miles,"
say '               or   '  ndist  " nautical or air miles."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SURFACEDISTANCE subroutine──────────*/
surfaceDistance: arg th1,ph1,th2,ph2   /*use haversine formula for dist.*/
numeric digits digits()*2              /*double the number of digits.   */
radius = 6372.8                        /*earth's mean radius in km      */
   ph1 = d2r(ph1-ph2)                  /*convert degs──►radians & reduce*/
   ph2 = d2r(ph2)                      /*   "      "       "    "    "  */
   th1 = d2r(th1)                      /*   "      "       "    "    "  */
   th2 = d2r(th2)
                   x = cos(ph1) * cos(th1) - cos(th2)
                   y = sin(ph1) * cos(th1)
                   z = sin(th1) - sin(th2)
return radius * 2 * aSin(sqrt(x**2+y**2+z**2)/2 )
/*═════════════════════════════general 1-line subs══════════════════════*/
d2d: return arg(1) // 360              /*normalize degrees.             */
d2r: return r2r(arg(1)*pi() / 180)     /*normalize and convert deg──►rad*/
r2d: return d2d((arg(1)*180 / pi()))   /*normalize and convert rad──►deg*/
r2r: return arg(1) // (2*pi())         /*normalize radians.             */
p:   return word(arg(1),1)             /*pick the first of two words.   */
pi:  if $.pipi==''  then $.pipi=$pi();  return $.pipi        /*return π.*/

aCos: procedure expose $.; arg x; if x<-1|x>1 then call $81r -1,1,x,"ACOS"
         return .5*pi()-aSin(x)        /*$81R  says arg is out of range,*/
                                       /*    and it isn't included here.*/
aSin: procedure expose $.;    parse arg x
         if x<-1 | x>1   then call $81r -1,1,x,"ASIN";    s=x*x
         if abs(x)>=.7   then return sign(x)*aCos(sqrt(1-s),'-ASIN')
         z=x;  o=x;  p=z;     do j=2 by 2;  o=o*s*(j-1)/j;  z=z+o/(j+1)
         if z=p then leave;   p=z;  end;                  return z

cos:  procedure expose $.;    parse arg x;       x=r2r(x);        a=abs(x)
         numeric fuzz min(9,digits()-9);        if a=pi()   then return -1
         if a=pi()/2 | a=2*pi() then return 0;  if a=pi()/3 then return .5
         if a=2*pi()/3  then return -.5;        return .sinCos(1,1,-1)

sin:  procedure expose $.;    parse arg x;      x=r2r(x);
         numeric fuzz  min(5,digits()-3)
         if abs(x)=pi()  then return 0;         return .sinCos(x,x,1)

.sinCos: parse arg z,_,i; x=x*x; p=z; do k=2 by 2; _=-_*x/(k*(k+i)); z=z+_
         if z=p then leave; p=z;  end;  return z    /*used by SIN & COS.*/

sqrt: procedure;  parse arg x;  if x=0 then return 0;  d=digits()
  numeric digits 11; g=.sqrtGuess(); do j=0 while p>9; m.j=p; p=p%2+1; end
  do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g);end
  numeric digits d;  return g/1
.sqrtGuess:       numeric form;     m.=11;             p=d+d%4+2
  parse value format(x,2,1,,0) 'E0' with g 'E' _ .;    return  g*.5'E'_%2

$pi: return ,
'3.1415926535897932384626433832795028841971693993751058209749445923078'||,
'164062862089986280348253421170679821480865132823066470938446095505822'||,
'3172535940812848111745028410270193852110555964462294895493038196'
/*┌───────────────────────────────────────────────────────────────────────┐
  │ A note on built-in functions.  REXX doesn't have a lot of mathmatical │
  │ or  (particularly) trigomentric  functions,  so REXX programmers have │
  │ to write their own.  Usually, this is done once, or most likely,  one │
  │ is borrowed from another program.  Knowing this, the one that is used │
  │ has a lot of boilerplate in it.  Once coded and throughly debugged, I │
  │ put those commonly-used subroutines into the  "1-line sub"  section.  │
  │                                                                       │
  │ Programming note:  the  "general 1-line"  subroutines are taken from  │
  │ other programs that I wrote, but I broke up their one line of source  │
  │ so it can be viewed without shifting the viewing window.              │
  │                                                                       │
  │ The  "er 81"  [which won't happen here]  just shows an error telling  │
  │ the legal range for  ARCxxx  functions   (in this case:  -1 ──► +1).  │
  │                                                                       │
  │ Similarly,  the   SQRT   function checks for a negative argument      │
  │ [which again, won't happen here].                                     │
  │                                                                       │
  │ The pi constant (as used here) is actually a much more robust function│
  │ and will return up to one million digits in the real version.         │
  │                                                                       │
  │ One bad side effect is that, like a automobile without a hood, you see│
  │ all the dirty stuff going on.    Also, don't visit a sausage factory. │
  └───────────────────────────────────────────────────────────────────────┘ */
