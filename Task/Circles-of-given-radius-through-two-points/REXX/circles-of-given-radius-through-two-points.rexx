/*REXX pgm finds two circles with a specific radius given two  (X1,Y1) & (X2,Y2)  points*/
@.=; @.1= 0.1234   0.9876    0.8765    0.2345    2
     @.2= 0        2         0         0         1
     @.3= 0.1234   0.9876    0.1234    0.9876    2
     @.4= 0.1234   0.9876    0.8765    0.2345    0.5
     @.5= 0.1234   0.9876    0.1234    0.9876    0
say '     x1        y1        x2        y2     radius          circle1x  circle1y  circle2x  circle2y'
say '  ════════  ════════  ════════  ════════  ══════          ════════  ════════  ════════  ════════'
       do  j=1  while  @.j\=='';  parse var @.j  p1 p2 p3 p4 r           /*points, radii*/
       say f(p1)  f(p2)  f(p3)  f(p4)       center(r/1, 9)      "───► "        2circ(@.j)
       end      /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
2circ: procedure; parse arg px py qx qy r .;  x=(qx-px)/2;   y=(qy-py)/2
                                             bx=px + x;     by=py + y;  pb=sqrt(x**2+y**2)
       if r = 0  then return  'radius of zero yields no circles.'
       if pb==0  then return  'coincident points give infinite circles.'
       if pb >r  then return  'points are too far apart for the specified radius.'
       cb=sqrt(r**2 - pb**2);      x1=y * cb / pb;                  y1=x * cb / pb
                      return  f(bx-x1)   f(by+y1)   f(bx+x1)   f(by-y1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:     arg f;   f= right( format(f, , 4), 9);         _= f  /*format # with 4 dec digits*/
       if pos(.,f)>0 & pos('E',f)=0  then f= strip(f,'T',0) /*strip trailing 0s if .& ¬E*/
       return left( strip(f, 'T', .), length(_) )           /*strip trailing dec point. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; arg x; if x=0  then return 0;  d=digits(); numeric digits;  h=d+6;  m.=9
       numeric form;  parse value format(x,2,1,,0) 'E0'  with  g "E" _ .;  g=g *.5'e'_ % 2
         do j=0  while h>9;      m.j=h;               h=h%2+1;       end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end  /*k*/;  return g
