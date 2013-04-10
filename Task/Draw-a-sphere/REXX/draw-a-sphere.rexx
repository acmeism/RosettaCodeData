/*REXX program to express a lighted sphere with simple chars for shading*/
call drawSphere  19,  4,   2/10
call drawSphere  10,  2,   4/10
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────drawSphere subroutine───────────────*/
drawSphere: procedure;  parse arg r, k, ambient
if 1=='f1'x then shading='.:!*oe&#%@'                /*for EBCDIC machs.*/
            else shading='·:!ºoe@░▒▓'                /*for ASCI machines*/
                      lightSource = '30  30  -50'    /*the light source.*/
parse value  norm(lightSource)   with   s1 s2 s3     /*normalize light S*/
sLen=length(shading);  sLen1=sLen-1;  rr=r*r

  do   i=floor(-r)   to ceil(r)  ;    x=  i+.5;    xx=x**2;    aLine=
    do j=floor(-2*r) to ceil(2*r);    y=j/2+.5;    yy=y**2
    if xx+yy<=rr then do
                      parse value norm(x y sqrt(rr-xx-yy))  with  v1 v2 v3
                      dot=s1*v1 + s2*v2 + s3*v3
                      if dot>0 then dot=0
                      b=abs(dot)**k + ambient
                      if b<=0 then brite=sLenm1
                              else brite=trunc( max( (1-b) * sLen1, 0) )
                      aLine=aLine || substr(shading,brite+1,1)
                      end
                 else aLine=aLine' '
    end   /*j*/
  say strip(aLine,'trailing')
  end     /*i*/
return
/*─────────────────────────────────────"1-liner" subroutines────────────*/
ceil:  procedure;   parse arg x;   _=trunc(x);   return _ + (x>0) * (x\=_)
floor: procedure;   parse arg x;   _=trunc(x);   return _ - (x<0) * (x\=_)
norm: parse arg _1 _2 _3; _=sqrt(_1*_1+_2*_2+_3*_3); return _1/_ _2/_ _3/_
sqrt: procedure;  parse arg x;  if x=0 then return 0;   return .sqrt(x)/1
.sqrt:  d=digits();   numeric digits 11;   g=.sqrtGuess()
  do j=0 while p>9;  m.j=p;  p=p%2+1;  end
  do k=j+5 by -1 to 0; if m.k>11 then numeric digits m.k; g=.5*(g+x/g);end
  return g
.sqrtGuess:  numeric form;   m.=11;   p=d+d%4+2;   v=format(x,2,1,,0) 'E0'
             parse var v g 'E' _ .;   return g*.5'E'_%2
