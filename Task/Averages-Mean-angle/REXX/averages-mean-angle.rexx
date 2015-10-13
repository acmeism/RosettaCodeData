/*REXX program computes the   mean angle   (the angles expressed in degrees). */
numeric digits 50                      /*use  50  decimal digits of precision,*/
       showDig=10                      /* but only display ten decimal digits.*/
# = 350 10            ;      say showit(#, meanAngleD(#) )
# = 90 180 270 360    ;      say showit(#, meanAngleD(#) )
# = 10 20 30          ;      say showit(#, meanAngleD(#) )
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────subroutines──────────────────────────────────────────────*/
.sinCos: arg z,_,i; x=x*x;  do k=2 by 2 until p=z; p=z; _=-_*x/(k*(k+i)); z=z+_; end;  return z
$fuzz:  return  min(arg(1), max(1, digits() - arg(2) ) )
acos:   procedure; parse arg x;        return pi() * .5 - asin(x)
atan:   parse arg x; if abs(x)=1  then return pi()*.25 * sign(x);  return asin(x/sqrt(1 + x*x))
d2d:    return arg(1)           //  360
d2r:    return r2r(d2d(arg(1))  /   180   * pi() )
r2d:    return d2d((r2r(arg(1)) /   pi()) * 180)
r2r:    return arg(1)           //  (pi() *   2)
p:      return word(arg(1), 1)
pi: pi=3.1415926535897932384626433832795028841971693993751058209749445923078164062862;return pi

asin:   procedure; parse arg x 1 z 1 o 1 p;   xx=x*x
        if xx>=.5  then return sign(x) * acos(sqrt(1-xx))
          do j=2  by 2  until p=z;  p=z;  o=o*xx*(j-1)/j;  z=z+o/(j+1);  end
        return  z                      /* [↑]  compute until no more noise.   */

atan2:  procedure; parse arg y,x;                 call pi;       s=sign(y)
          select
          when x=0  then  z=s * pi * .5
          when x<0  then  if  y=0  then z=pi;   else z=s*(pi-abs(atan(y/x)))
          otherwise z=s * atan(y/x)
          end   /*select*/;                       return z

cos:    procedure; parse arg x;   x=r2r(x);       numeric fuzz  $fuzz(6, 3)
        a=abs(x);      if a=0 then return   1;    if a=pi    then return -1
        if a=pi*.5 | a=pi*1.5 then return   0;    if a=pi/3  then return .5
                  if a=pi*2/3 then return -.5;          return .sinCos(1, 1, -1)


meanAngleD:  procedure;  parse arg x;   numeric digits digits()+digits()%4
        _sin=0;   _cos=0;   n=words(x);         do j=1  for n;  !=d2r(word(x,j))
                                                _sin=_sin + sin(!)
                                                _cos=_cos + cos(!)
                                                end   /*j*/
        return  r2d(atan2(_sin/n, _cos/n))

showit: procedure expose showDig;  numeric digits showDig;  parse arg a,mA
        return left('angles='a,30)  'mean angle='  format(mA,,showDig,0)/1

sin:    procedure; parse arg x;   x=r2r(x);       numeric fuzz $fuzz(5, 3)
        if x=pi*.5           then return 1;    if x==pi*1.5 then return -1
        if abs(x)=pi | x=0   then return 0;       return .sinCos(x, x, +1)

sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
