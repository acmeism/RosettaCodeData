/*REXX pgm converts orbital elements ──► orbital state vectors  (angles are in radians).*/
numeric digits length( pi() )  -  length(.)      /*limited to pi len, but show 1/3 digs.*/
call orbV 1,   .1,   0,    355/113/6,    0,    0 /*orbital elements taken from:  Java   */
call orbV 1,   .1,  pi/18,      pi/6,  pi/4,   0 /*   "        "      "     "    Perl 6 */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
orbV: procedure;  parse arg  semiMaj, eccentricity, inclination, node, periapsis, anomaly
      say;     say center(' orbital elements ', 99, "═")
      say '            semi-major axis:'  fmt(semiMaj)
      say '               eccentricity:'  fmt(eccentricity)
      say '                inclination:'  fmt(inclination)
      say '   ascending node longitude:'  fmt(node)
      say '      argument of periapsis:'  fmt(periapsis)
      say '               true anomaly:'  fmt(anomaly)
      i= 1 0 0;          j= 0 1 0;        k= 0 0 1    /*define the  I,  J,  K   vectors.*/
      parse value rot(i, j, node)        with i '~' j /*rotate ascending node longitude.*/
      parse value rot(j, k, inclination) with j '~'   /*rotate the inclination.         */
      parse value rot(i, j, periapsis)   with i '~' j /*rotate the argument of periapsis*/
      if eccentricity=1  then L= 2
                         else L= 1 - eccentricity**2
      L= L * semiMaj                                  /*calculate the semi─latus rectum.*/
      c= cos(anomaly);               s= sin(anomaly)  /*calculate COS and SIN of anomaly*/
      r= L / (1 + eccentricity * c)
      @= s*r**2 / L;        speed= MA(i,  @*c - r*s,  j,   @*s + r*c)
      speed=    mulV( divV( speed, absV(speed) ), sqrt(2 / r  - 1 / semiMaj) )
      say '                   position:'  show( mulV( MA(i, c, j, s),  r) )
      say '                      speed:'  show( speed);            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
absV: procedure; parse arg x y z;              return sqrt(x**2  +  y**2  +  z**2)
divV: procedure; parse arg x y z, div;         return  (x / div)    (y / div)    (z / div)
mulV: procedure; parse arg x y z, mul;         return  (x * mul)    (y * mul)    (z * mul)
show: procedure; parse arg a b c;              return '('fmt(a)","   fmt(b)','   fmt(c)")"
fmt:  procedure; parse arg #;  return strip( left( left('', #>=0)# / 1, digits() %3), 'T')
MA:   procedure; parse arg x y z,@,a b c,$;    return  (x*@ + a*$) (y*@ + b*$) (z*@ + c*$)
pi:   pi= 3.1415926535897932384626433832795028841971693993751058209749445923;    return pi
rot:  procedure; parse arg i,j,$; return MA(i,cos($),j,sin($))'~'MA(i, -sin($), j, cos($))
r2r:  return arg(1)  //  (pi() * 2)                /*normalize radians ──► a unit circle*/
.sinCos: arg z 1 _,i; do k=2 by 2 until p=z; p=z; _= -_*$ /(k*(k+i)); z=z+_; end; return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos:  procedure; arg x;  x= r2r(x);   if x=0  then return 1;    a= abs(x);    Hpi= pi * .5
      numeric fuzz min(6, digits() - 3);        if a=pi       then return -1
      if a=Hpi | a=Hpi*3  then return   0;      if a=pi / 3   then return .5
      if a=pi * 2 / 3     then return '-.5';    $= x * x;          return .sinCos(1, -1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sin:  procedure; arg x;  x= r2r(x);   numeric fuzz min(5, max(1, digits() - 3) )
      if x=0  then return 0;   if x=pi*.5  then return 1;   if x==pi*1.5  then return -1
      if abs(x)=pi  then return 0;              $= x * x;          return .sinCos(x, 1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; arg x;  if x=0  then return 0;  d= digits();  numeric form; m.= 9; h= d+6
      numeric digits;  parse value format(x,2,1,,0) 'E0' with g 'E' _ .;  g= g *.5'e'_ % 2
        do j=0  while h>9;        m.j= h;              h= h % 2  +  1;    end
        do k=j+5  to 0  by '-1';  numeric digits m.k;  g= (g+x/g) * .5;   end;    return g
