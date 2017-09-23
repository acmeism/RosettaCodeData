/*REXX program expresses a  lighted sphere  with  simple characters  used for shading.  */
call drawSphere  19,  4,   2/10                  /*draw a sphere with a radius of  19.  */
call drawSphere  10,  2,   4/10                  /*  "  "    "     "  "    "    "  ten. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ceil:  procedure;   parse arg x;  _=trunc(x);                     return _ + (x>0) *(x\=_)
floor: procedure;   parse arg x;  _=trunc(x);                     return _ - (x<0) *(x\=_)
norm:  parse arg $a $b $c;        _=sqrt($a**2 + $b**2 + $c**2);  return  $a/_  $b/_  $c/_
/*──────────────────────────────────────────────────────────────────────────────────────*/
drawSphere: procedure;  parse arg r, k, ambient              /*get the arguments from CL*/
       if 5=='f5'x  then shading= ".:!*oe&#%@"               /* EBCDIC dithering chars. */
                    else shading= "·:!°oe@░▒▓"               /* ASCII      "       "    */
       lightSource= '30  30  -50'                            /*position of light source.*/
       parse value  norm(lightSource)   with   s1 s2 s3      /*normalize light source.  */
       shadeLen=length(shading) - 1;    rr=r**2;      r2=r+r /*handy─dandy variables.   */

         do   i=floor( -r)  to ceil( r);   x=i       + .5;        xx=x**2;            $=
           do j=floor(-r2)  to ceil(r2);   y=j * .5  + .5;        yy=y**2
           if xx+yy<=rr  then do                             /*is point within sphere ? */
                              parse value  norm(x  y  sqrt(rr-xx-yy) )   with   v1  v2  v3
                              dot=s1*v1  +  s2*v2  +  s3*v3  /*the dot product of the Vs*/
                              if dot>0  then dot=0           /*if positive, make it zero*/     /*◄■■■■ same as:  dot=max(0, dot) */
                              if dot>0  then dot=0           /*if positive, make it zero*/
                              b=-dot**k  +  ambient          /*calculate the brightness.*/
                              if b<=0   then brite=shadeLen
                                        else brite=max( (1-b) * shadeLen,  0)  % 1
                              $=($)substr(shading, brite + 1, 1)
                              end                            /* [↑]  build display line.*/
                         else $=$' '                         /*append a blank to line.  */
           end   /*j*/                                       /*[↓] strip trailing blanks*/
         say strip($, 'T')                                   /*show a line of the sphere*/
         end     /*i*/                                       /* [↑]  display the sphere.*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure;  parse arg x;  if x=0  then return 0;   d=digits();  m.=9;  numeric form
       numeric digits; parse value format(x,2,1,,0) 'E0'  with  g "E" _ .;    g=g*.5'e'_%2
       h=d+6;       do j=0  while h>9;      m.j=h;              h=h%2+1;        end  /*j*/
                    do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;   end  /*k*/
       numeric digits d;                    return g/1
