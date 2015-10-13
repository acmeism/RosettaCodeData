/*REXX program finds two circles with a specific radius given two (X,Y) points*/
@.=; @.1=0.1234   0.9876    0.8765    0.2345      2
     @.2=0        2         0         0           1
     @.3=0.1234   0.9876    0.1234    0.9876      2
     @.4=0.1234   0.9876    0.8765    0.2345      0.5
     @.5=0.1234   0.9876    0.1234    0.9876      0
say '     x1        y1        x2        y2     radius          circle1x  circle1y  circle2x  circle2y'
say '  ════════  ════════  ════════  ════════  ══════          ════════  ════════  ════════  ════════'
      do  j=1  while  @.j\==''               /*process the points and radii.  */
         do k=1  for 4;  w.k=f(word(@.j,k))  /*format # with 4 decimal digits.*/
         end   /*k*/
      say  w.1  w.2  w.3  w.4  center(word(@.j,5)/1,9)    "───► "     2circ(@.j)
      end      /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
2circ: procedure;   parse arg px py qx qy r .;       x=(qx-px)/2;    y=(qy-py)/2
       bx=px+x;       by=py+y;          pb=sqrt(x**2+y**2)
       if r=0   then return 'radius of zero yields no circles.'
       if pb=0  then return 'coincident points give infinite circles.'
       if pb>r  then return 'points are too far apart for the specified radius.'
       cb=sqrt(r**2-pb**2);                          x1=y*cb/pb;     y1=x*cb/pb
                     return  f(bx-x1)   f(by+y1)   f(bx+x1)   f(by-y1)
/*────────────────────────────────────────────────────────────────────────────*/
f: f=right(format(arg(1),,4),9);   _=f    /*format # with four decimal digits.*/
   if pos(.,f)\==0 then f=strip(f,'T',0)  /*strip trailing 0s if decimal point*/
   return left(strip(f,'T',.),length(_))  /*maybe strip trailing decimal point*/
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
