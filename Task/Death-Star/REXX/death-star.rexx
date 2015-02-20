/*REXX program to draw a "deathstar", a sphere with another subtracted. */
signal on syntax; signal on noValue    /*handle REXX program errors.    */
numeric digits 20                      /*use a fair amount of precision.*/
                             lightSource = norm('-50  30  50')
call drawSphereM   2,  .5,   lightSource
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DRAWSPHEREM subroutine──────────────*/
drawSphereM: procedure;  parse arg k,ambient,lightSource
z1=0; z2=0
parse var  lightSource   s1 s2 s3      /*break-apart the light source.  */

                 shading='·:!ºoe@░▒▓'  /*shading chars for ASCI machines*/
if 1=='f1'x then shading='.:!*oe&#%@'  /*shading chars for EBCDIC machs.*/

shadesLength=length(shading)
shades.=' ';                    do i=1  for shadesLength
                                shades.i=substr(shading,i,1)
                                end   /*i*/

ship= 20 20  0 20 ;     parse var ship ship.cx ship.cy ship.cz ship.radius
hole=' 1  1 -6 20';     parse var hole hole.cx hole.cy hole.cz hole.radius

  do   i=floor(ship.cy-ship.radius) to ceil(ship.cy+ship.radius)+1;  y=i+.5;  aLine=
    do j=trunc(floor(ship.cx - 2*ship.radius) )     to ,
         trunc( ceil(ship.cx + 2*ship.radius) +1)
    x=.5*(j-ship.cx) + .5 + ship.cx;    !bg=0;    !pos=0;    !neg=0;    z1=0;   z2=0
    ?=hitSphere(ship, x, y);            zb1=z1;   zb2=z2

    if \? then !bg=1                                                             /*ray lands in blank space, draw the background.        */
          else do
               ?=hitsphere(hole, x, y);  zs1=z1;   zs2=z2
               if \? then !pos=1                                                 /*ray hits ship but not the hole, draw ship surface.    */
                     else if zs1>zb1 then !pos=1                                 /*ray hits both, but ship front surface is closer.      */
                                     else if zs2>zb2 then !bg=1                  /*ship surface is inside hole,  show background.        */
                                                     else if zs2>zb1 then !neg=1 /*back surface in hole is inside ship, the only place hole surface will be shown.*/
                                                                     else !pos=1
               end
      select
      when !bg   then do;  aLine=aLine' ';                iterate j;   end
      when !pos  then      vec_=V3(x-ship.cx y-ship.cy zb1-ship.cz)
      when !neg  then      vec_=V3(hole.cx-x hole.cy-y hole.cz-zs2)
      end    /*select*/

    nvec=norm(vec_)
    b=dot.(lightSource,nvec)**k + ambient
    intensity=trunc((1-b) * shadesLength)
    intensity=min(shadesLength, max(0, intensity)) + 1
    aLine=aLine || shades.intensity
    end     /*j*/

  if aline\=''  then say strip(aLine,'T')
  end       /*i*/

return
/*──────────────────────────────────HITSPHERE subroutine────────────────*/
hitSphere: procedure expose z1 z2; parse arg $.cx $.cy $.cz $.radius, x0, y0
           x=x0-$.cx
           y=y0-$.cy
           zsq=$.radius**2 - (x**2 + y**2);        if zsq<0  then return 0
           _=sqrt(zsq)
           z1=$.cz-_
           z2=$.cz+_
           return 1
/*──────────────────────────────────one─liner subroutines────────────────────────────────────────────────────────────────────────────────────────────────────────*/
dot.:    procedure; parse arg x,y; d=dot(x,y); if d<0 then return -d; return 0
dot:     procedure; parse arg x,y; s=0; do j=1 for words(x); s=s+word(x,j)*word(y,j); end; return s
err:     say; say; say center(' error! ',max(40,linesize()%2),"*"); say;  do j=1 for arg(); say arg(j); say; end; say; exit 13
ceil:    procedure;   parse arg x;   _=trunc(x);   return _ + (x>0) * (x\=_)
floor:   procedure;   parse arg x;   _=trunc(x);   return _ - (x<0) * (x\=_)
norm:    parse arg _1 _2 _3; _=sqrt(_1**2+_2**2+_3**2); return _1/_ _2/_ _3/_
noValue: syntax: call err 'REXX program' condition('C') "error", condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
sqrt:    procedure;  parse arg x;  if x=0 then return 0;   return .sqrt(x)/1
.sqrt:   d=digits();numeric digits 11;g=.sqrtG();do j=0 while p>9;m.j=p;p=p%2+1;end;do k=j+5 by -1 to 0;if m.k>11 then numeric digits m.k;g=.5*(g+x/g);end;return g
.sqrtG:  numeric form;   m.=11;   p=d+d%4+2;   v=format(x,2,1,,0) 'E0';  parse var v g 'E' _ .;   return g*.5'E'_%2
V3:      procedure; parse arg v; return norm(v)
