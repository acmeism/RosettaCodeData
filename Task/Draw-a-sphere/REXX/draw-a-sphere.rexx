/*REXX program expresses a lighted sphere with simple chars for shading.*/
call drawSphere  19,  4,   2/10        /*draw a sphere with radius 19.  */
call drawSphere  10,  2,   4/10        /*draw a sphere with radius ten. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DRAWSPHERE subroutine───────────────*/
drawSphere: procedure;  parse arg r, k, ambient      /*get the arguments*/
if 1=='f1'x  then shading='.:!*oe&#%@'               /*EBCDIC dithering.*/
             else shading='·:!°oe@░▒▓'               /*ASCII      "     */
lightSource = '30  30  -50'                          /*the light source.*/
parse value  norm(lightSource)   with   s1 s2 s3     /*normalize light S*/
sLen=length(shading);   sLen1=sLen-1;   rr=r*r       /*handy-dandy vars.*/

  do   i=floor(-r)   to ceil(r)  ;    x=  i+.5;    xx=x**2;       aLine=
    do j=floor(-2*r) to ceil(2*r);    y=j/2+.5;    yy=y**2
    if xx+yy<=rr then do                             /*within the phere?*/
                      parse value norm(x y sqrt(rr-xx-yy))  with  v1 v2 v3
                      dot=s1*v1 + s2*v2 + s3*v3      /*dot product of Vs*/
                      if dot>0  then dot=0           /*if pos, make it 0*/
                      b=abs(dot)**k + ambient        /*calc. brightness.*/
                      if b<=0 then brite=sLenm1
                              else brite=trunc( max( (1-b) * sLen1, 0) )
                      aLine=aLine || substr(shading,brite+1,1)  /*build.*/
                      end
                 else aLine=aLine' '                 /*append a blank.  */
    end   /*j*/
  say strip(aLine,'trailing')                        /*show a line of it*/
  end     /*i*/                                      /* [↑]  show sphere*/
return
/*─────────────────────────────────────subroutines────────────────────────────*/
ceil:  procedure;   parse arg x;   _=trunc(x);   return _ + (x>0) * (x\=_)
floor: procedure;   parse arg x;   _=trunc(x);   return _ - (x<0) * (x\=_)
norm:  parse arg _1 _2 _3;   _=sqrt(_1**2+_2**2+_3**2);   return _1/_ _2/_ _3/_
/*─────────────────────────────────────SQRT subroutine────────────────────────*/
sqrt: procedure; parse arg x; if x=0 then return 0; d=digits(); p=d+d%4+2; m.=11
 numeric digits m.;numeric form;parse value format(x,2,1,,0) 'E0' with g 'E' _ .
 g=g*.5'E'_%2;                         do j=0  while p>9;  m.j=p;  p=p%2+1;  end
       do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g); end
 numeric digits d;     return g/1
