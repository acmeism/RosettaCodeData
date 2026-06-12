/*REXX program calculates  where  (or if)  a  line  intersects  (or tengents)  a cirle. */
/*───────────────────────────────────── line= x1,y1  x2,y2;   circle is at 0,0, radius=r*/
parse arg x1 y1 x2 y2 cx cy r .                  /*obtain optional arguments from the CL*/
if x1=='' | x1==","  then x1=  0                 /*Not specified?  Then use the default.*/
if y1=='' | y1==","  then y1= -3                 /* "      "         "   "   "     "    */
if x2=='' | x2==","  then x2=  0                 /* "      "         "   "   "     "    */
if y2=='' | y2==","  then y2=  6                 /* "      "         "   "   "     "    */
if cx=='' | cx==","  then cx=  0                 /* "      "         "   "   "     "    */
if cy=='' | cy==","  then cy=  0                 /* "      "         "   "   "     "    */
if r =='' | r ==","  then r =  4                 /* "      "         "   "   "     "    */
x_1= x1;         x1= x1 + cx;        y_1= y1;        y1= y1 + cy
x_2= x2;         x2= x2 + cx;        y_2= y2;        y2= y2 + cy
dx= x2 - x1;     dy= y2 - y1
                                        dr2= dx**2 + dy**2
  D=  x1 * y2   -   x2 * y1;               r2= r**2;    D2= D**2
                                   $= sqrt(r2 * dr2  -  D2)
ix1= ( D * dy   +   sgn(dy) * dx * $) / dr2
ix2= ( D * dy   -   sgn(dy) * dx * $) / dr2
iy1= (-D * dx   +   abs(dy)      * $) / dr2
iy2= (-D * dx   -   abs(dy)      * $) / dr2
incidence= (r2 * dr2  -  D2)  /  1
say 'incidence='   incidence
                         @potla= 'points on the line are: '
if incidence<0  then do
                     say @potla ' ('||x_1","y_1')  and  ('||x_2","y_2')  are: '  ix1","iy1
                     say "The line doesn't intersect the circle with radius: "   r
                     end
if incidence=0  then do
                     say @potla ' ('||x_1","y_1')  and  ('||x_2","y_2')  are: '  ix1","iy1
                     say "The line is tangent to circle with radius: "           r
                     end
if incidence>0  then do
                     say @potla ' ('||x_1","y_1')  and  ('||x_2","y_2')  are: '  ix1","iy1
                     say "The line is secant to circle with radius: "            r
                     end
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sgn:  procedure;  if arg(1)<0  then return -1;           return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  numeric digits;  h=d+6
      numeric form; m.=9; parse value format(x,2,1,,0) 'E0' with g "E" _ .; g=g *.5'e'_ %2
        do j=0  while h>9;      m.j= h;              h= h%2 + 1;      end  /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g= (g+x/g) *.5;  end  /*k*/; return g
