/*REXX program generates  10,000  normally distributed numbers  (Gaussian distribution).*/
numeric digits 20                                /*use twenty decimal digs for accuracy.*/
parse arg n seed .                               /*obtain optional arguments from the CL*/
if n==''  |  n==","     then n= 10000            /*Not specified?  Then use the default.*/
if datatype(seed, 'W')  then call random ,,seed  /*seed is for repeatable RANDOM numbers*/
call pi                                          /*call subroutine to define pi constant*/
        do g=1  for n;   #.g= sqrt( -2 * ln( rand() ) )      *      cos( 2 * pi * rand() )
        end   /*g*/                              /* [↑]  uniform random number ───► #.g */
s= 0
mn= #.1;        mx= mn;        noise= n * .0005  /*calculate the noise:  1/20th %  of N.*/
ss= 0
        do j=1  for n;         _= #.j            /*the sum,  and  the sum of squares.   */
        s= s + _;              ss= ss  +  _ * _  /*the sum,  and  the sum of squares.   */
        mn= min(mn, _);        mx= max(mx, _)    /*find the minimum  and the maximum.   */
        end   /*j*/
!.= 0
say 'number of data points = '   fmt(n  )
say '              minimum = '   fmt(mn )
say '              maximum = '   fmt(mx )
say '      arithmetic mean = '   fmt(s/n)
say '   standard deviation = '   fmt(sqrt( ss/n - (s/n) **2) )
?mn= !.1;    ?mx= ?mn                            /*define minimum & maximum value so far*/
parse value  scrSize()  with  sd sw .            /*obtain the (true) screen size of term*/  /*◄──not all REXXes have this BIF*/
sdE= sd - 4                                      /*the effective (usable) screen depth. */
swE= sw - 1                                      /* "      "         "        "   width.*/
$= 1 / max(1, mx-mn) * sdE                       /*$  is used for scaling depth of histo*/
            do i=1  for n; ?= trunc((#.i-mn) *$) /*calculate the relative line.         */
            !.?= !.? + 1                         /*bump the counter.                    */
            ?mn= min(?mn, !.?)                   /*find the minimum.                    */
            ?mx= max(?mx, !.?)                   /*  "   "  maximum.                    */
            end   /*i*/
f= swE/?mx                                                /*limit graph to 1 full screen*/
            do h=0  for sdE;     _= !.h                   /*obtain a data point.        */
            if _>noise  then say copies('─', trunc(_*f) ) /*display a bar of histogram. */
            end   /*h*/                                   /*[↑]  use a hyphen for histo.*/
exit                                             /*stick a fork in it,  we're all done. */
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
fmt:  parse arg @; return left('', (@>=0) + 2 * datatype(@, 'W'))@  /*prepend a blank if #>=0, add 2 blanks if whole.*/
e:    e = 2.7182818284590452353602874713526624977572470936999595749669676277240766303535;                     return e
pi:   pi= 3.1415926535897932384626433832795028841971693993751058209749445923078164062862;                     return pi
r2r:  return arg(1)  //  (pi() * 2)                                 /*normalize the given angle (in radians) to ±2pi.*/
rand: return random(1, 1e5)  /  1e5                                 /*REXX generates uniform random postive integers.*/
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
ln:   procedure; parse arg x,f; call e; ig= x>1.5; is= 1 -2*(ig\==1); ii= 0; xx= x;  do while ig & xx>1.5 | \ig & xx<.5
      _= e;  do k=-1; iz= xx*_ **-is;  if k>=0 & (ig & iz<1 | \ig & iz>.5)  then leave;  _= _*_; izz= iz; end;  xx= izz
      ii= ii +is*2**k; end; x= x*e**-ii-1; z=0; _=-1; p=z; do k=1;_=-_*x;z=z+_/k;if z=p then leave;p=z;end; return z+ii
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
cos:  procedure; parse arg x; x=r2r(x); a=abs(x); hpi= pi*.5;  numeric fuzz min(6, digits()-3); if a=pi  then return -1
      if a=hpi | a=hpi*3  then return 0;   if a=pi/3  then return .5;   if a=pi*2/3 then return -.5;   z= 1;   _= 1
      x= x*x;  p= z;      do k=2  by 2; _= -_ * x / (k*(k-1));   z= z + _;  if z=p  then leave;  p= z; end;    return z
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d= digits();   m.= 9;   numeric digits;   numeric form;   h= d+6
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .; g=g*.5'e'_%2;    do j=0  while h>9; m.j=h; h=h%2+1; end /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end  /*k*/;          numeric digits d;   return g/1
