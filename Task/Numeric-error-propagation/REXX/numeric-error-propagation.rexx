/*REXX program calculates the distance between two points (2D)  with error propagation. */
parse arg a b .                                           /*obtain arguments from the CL*/
if a=='' | a==","  then a= '100±1.1,  50±1.2'             /*Not given? Then use default.*/
if b=='' | b==","  then b= '200±2.2, 100±2.3'             /* "    "      "   "     "    */
parse var a  ax ',' ay;     parse var b  bx ',' by        /*obtain X,Y from A & B point.*/
parse var ax ax '±' axe;    parse var bx bx '±' bxE       /*   "   err   "  Ax  and  Bx.*/
parse var ay ay '±' aye;    parse var by by '±' byE       /*   "    "    "  Ay   "   By.*/
if axE==''  then axE= 0;    if bxE==""  then bxE= 0       /*No error?  Then use default.*/
if ayE==''  then ayE= 0;    if byE==""  then byE= 0       /* "   "       "   "     "    */
   say ' A point (x,y)=   ' ax "±"   axE',   ' ay "±" ayE /*display  A  point (with err)*/
   say ' B point (x.y)=   ' bx "±"   bxE',   ' by "±" byE /*   "     B    "      "   "  */
   say                                                    /*blank line for the eyeballs.*/
dx= ax-bx;  dxE= sqrt(axE**2 + bxE**2); xe= #(dx, 2, dxE) /*compute  X distances (& err)*/
dy= ay-by;  dyE= sqrt(ayE**2 + byE**2); ye= #(dy, 2, dyE) /*   "     Y     "      "  "  */
D= sqrt(dx**2 + dy**2)                                    /*compute the   2D  distance. */
   say 'distance=' D "±" #(D**2, .5, sqrt(xE**2 + yE**2)) /*display  "     "      "     */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#: procedure; arg x,p,e; if p=.5 then z=1/sqrt(abs(x)); else z=abs(x)**(p-1); return p*e*z
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  numeric digits;  h=d+6
      numeric form;  parse value format(x,2,1,,0) 'E0' with g "E" _ .;    g=g * .5'e'_ % 2
      m.=9;       do j=0  while h>9;       m.j=h;               h=h%2+1;        end  /*j*/
                  do k=j+5  to 0  by -1;   numeric digits m.k;  g=(g+x/g)*.5;   end  /*k*/
      numeric digits d;                    return g/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  numeric digits;  h=d+6
      numeric form;  parse value format(x,2,1,,0) 'E0' with g "E" _ .;   g= g * .5'e'_ % 2
      m.= 9;   do j=0  while h>9;       m.j= h;               h= h%2+1;        end  /*j*/
               do k=j+5  to 0  by -1;   numeric digits m.k;   g= (g+x/g)*.5;   end  /*k*/
      numeric digits d;                 return g/1
