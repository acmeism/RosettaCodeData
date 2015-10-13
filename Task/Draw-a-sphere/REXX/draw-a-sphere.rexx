/*REXX program expresses a lighted sphere  with simple characters for shading.*/
call drawSphere  19,  4,   2/10        /*draw a sphere with a radius of  19.  */
call drawSphere  10,  2,   4/10        /*  "  "    "     "  "    "    "  ten. */
exit                                   /*stick a fork in it,  we're all done. */
/*─────────────────────────────────────one─liner subroutines──────────────────*/
ceil:  procedure;   parse arg x;   _=trunc(x);          return _ + (x>0) *(x\=_)
floor: procedure;   parse arg x;   _=trunc(x);          return _ - (x<0) *(x\=_)
norm:  parse arg _1 _2 _3;  _=sqrt(_1**2+_2**2+_3**2);  return _1/_  _2/_  _3/_
/*──────────────────────────────────DRAWSPHERE subroutine─────────────────────*/
drawSphere: procedure;  parse arg r, k, ambient    /*get the arguments from CL*/
if 1=='f1'x  then shading= ".:!*oe&#%@"             /* EBCDIC dithering chars. */
             else shading= "·:!°oe@░▒▓"             /* ASCII      "       "    */
lightSource = '30  30  -50'                        /*position of light source.*/
parse value  norm(lightSource)   with   s1 s2 s3   /*normalize light source.  */
sLen=length(shading)-1;          rr=r*r            /*handy─dandy variables.   */

  do   i=floor(-r)   to ceil(r)  ;    x=  i+.5;    xx=x**2;       $=
    do j=floor(-2*r) to ceil(r+r);    y=j/2+.5;    yy=y**2
    if xx+yy<=rr  then do                          /*is point within sphere ? */
                       parse value  norm(x y sqrt(rr-xx-yy))   with   v1  v2  v3
                       dot=s1*v1  + s2*v2  + s3*v3 /*the dot product of the Vs*/
                       if dot>0  then dot=0        /*if positive, make it zero*/
                       b=abs(dot)**k + ambient     /*calculate the brightness.*/
                       if b<=0   then brite=sLen
                                 else brite=trunc( max( (1-b) * sLen, 0) )
                       $=($)substr(shading,brite+1,1)  /*build a display line.*/
                       end
                  else $=$' '                      /*append a blank to line.  */
    end   /*j*/
  say strip($,'trailing')                          /*show a line of the sphere*/
  end     /*i*/                                    /* [↑]  display the sphere.*/
return
/*──────────────────────────────────SQRT subroutine───────────────────────────*/
sqrt:  procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
       numeric digits 9; numeric form; h=d+6;  if x<0  then do; x=-x; i='i'; end
       parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
          do j=0  while h>9;      m.j=h;              h=h%2+1;        end  /*j*/
          do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;   end  /*k*/
       numeric digits d;     return (g/1)i            /*make complex if X < 0.*/
