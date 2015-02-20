/*REXX pgm finds 2 circles with a specific radius given two (X,Y) points*/
@.  =
@.1 =   0.1234    0.9876    0.8765    0.2345     2
@.2 =   0         2         0         0          1
@.3 =   0.1234    0.9876    0.1234    0.9876     2
@.4 =   0.1234    0.9876    0.8765    0.2345     0.5
@.5 =   0.1234    0.9876    0.1234    0.9876     0
say '     x1        y1        x2        y2     radius          circle1x  circle1y  circle2x  circle2y'
say '  ────────  ────────  ────────  ────────  ──────          ────────  ────────  ────────  ────────'
      do  j=1  while  @.j\==''         /*process all given points&radius*/
         do k=1  for 4;  w.k=f(word(@.j,k))   /*format # with 4 dec digs*/
         end   /*k*/
      say w.1 w.2 w.3 w.4 center(word(@.j,5)/1,9)  "───► " twoCircles(@.j)
      end      /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────F subroutine────────────────────────*/
f: return right(format(arg(1),,4),9)   /*format a # with 4 decimal digs.*/
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure; parse arg x; if x=0 then return 0; d=digits(); numeric digits 11
numeric form; m.=11; p=d+d%4+2; parse value format(x,2,1,,0) 'E0'  with g 'E' _ .
g=g*.5'E'_%2;             do j=0  while p>9;  m.j=p;  p=p%2+1;   end
 do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g); end
numeric digits d;  return g/1
/*──────────────────────────────────TWOCIRCLES subroutine───────────────*/
twoCircles:  procedure;   parse arg px py qx qy r .
x=(qx-px)/2;   y=(qy-py)/2;    bx=px+x;    by=py+y;     pb=sqrt(x**2+y**2)
if r=0        then return  'radius of zero gives no circles'
if pb=0       then return  'coincident points give infinite circles'
if pb>r       then return  'points are too far apart for the given radius'
cb=sqrt(r**2-pb**2);      x1=y*cb/pb;     y1=x*cb/pb
return   f(bx-x1)   f(by+y1)   f(bx+x1)   f(by-y1)
