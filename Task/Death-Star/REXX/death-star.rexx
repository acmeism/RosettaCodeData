/*REXX pgm draws a sphere with another sphere subtracted where superimposed.  */
call deathStar   2,  .5,  v3('-50  30  50')
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────one─liner subroutines────────────────────────────────────────*/
dot.:   procedure; parse arg x,y; d=dot(x,y); if d<0 then return -d; return 0
dot:    procedure; parse arg x,y; s=0; do j=1 for words(x); s=s+word(x,j)*word(y,j); end;  return s
ceil:   procedure; parse arg x;   _=trunc(x);                        return _+(x>0)*(x\=_)
floor:  procedure; parse arg x;   _=trunc(x);                        return _-(x<0)*(x\=_)
v3:     procedure; parse arg a b c; s=sqrt(a**2+b**2+c**2);          return a/s  b/s  c/s
/*──────────────────────────────────DEATHSTAR subroutine──────────────────────*/
deathStar: procedure; parse arg k,ambient,sun           /* [↓]  draw deathstar*/
parse var  sun   s1 s2 s3              /*identify the lightsource coördinates.*/

if 6=='f6'x then shading= '.:!*oe&#%@' /*shading characters for EBCDIC machine*/
            else shading= '·:!ºoe@░▒▓' /*   "        "       "  ASCII     "   */

shadesLen=length(shading)
shades.=' ';    do i=1  for shadesLen;  shades.i=substr(shading,i,1);  end /*i*/

ship= 20 20  0 20 ;     parse var  ship   ship.cx  ship.cy  ship.cz  ship.radius
hole=' 1  1 -6 20';     parse var  hole   hole.cx  hole.cy  hole.cz  hole.radius

  do   i=floor(ship.cy-ship.radius)           to ceil(ship.cy+ship.radius) +1;  y=i+.5;  $=
    do j=trunc(floor(ship.cx-2*ship.radius))  to trunc(ceil(ship.cx+2*ship.radius) +1)
    x=.5*(j-ship.cx)+.5+ship.cx;    !.=0
    ?=hitSphere(ship, x, y);                 b1=!.z1;   b2=!.z2             /*?  is boolean,  "true"  indicates ray hits the sphere.*/

    if \? then !.bg=1                                                       /*ray lands in blank space, so draw the background.     */
          else do; ?=hitSphere(hole, x, y);  s1=!.z1;   s2=!.z2
               if \? then !.pos=1                                           /*ray hits ship but not the hole, so draw ship surface. */
                     else if s1>b1 then !.pos=1                             /*ray hits both, but ship front surface is closer.      */
                                   else if s2>b2 then !.bg=1                /*ship surface is inside hole,  so show the background. */
                                                 else if s2>b1 then !.neg=1 /*hole back surface is inside ship; the only place hole surface will be shown.*/
                                                               else !.pos=1
               end
      select
      when !.bg   then do;    $=$' ';     iterate j;   end                  /*append a blank to the line to be displayed.*/
      when !.pos  then vec_=v3(x-ship.cx  y-ship.cy  b1-ship.cz)
      when !.neg  then vec_=v3(hole.cx-x  hole.cy-y  hole.cz-s2)
      end    /*select*/

    b=1+min(shadesLen,max(0,trunc((1-(dot.(sun,v3(vec_))**k+ambient))*shadesLen)))
    $=$ || shades.b                       /*B  is the ray's intensity│brightness*/
    end      /*j*/                        /* [↑]  build line for showing sphere.*/

  if $\=''  then say strip($,'T')         /*strip any trailing blanks from line.*/
  end        /*i*/                        /* [↑]  show all lines for the sphere.*/

return
/*──────────────────────────────────HITSPHERE subroutine──────────────────────────*/
hitSphere: procedure expose !.; parse arg xx yy zz r,x0,y0;        x=x0-xx;  y=y0-yy
z=r**2-(x**2+y**2); if z<0  then return 0; _=sqrt(z); !.z1=zz-_; !.z2=zz+_; return 1
/*──────────────────────────────────SQRT subroutine───────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
