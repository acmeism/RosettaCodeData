/*REXX program to compute the mean angle  (angles expressed in degrees).*/
numeric digits 50                      /*use fifty digits of precision. */
showDigs=10                            /* ... but only show ten digits. */
#=350 10          ;   say showit(#, meanAngleD(#))
#=90 180 270 360  ;   say showit(#, meanAngleD(#))
#=10 20 30        ;   say showit(#, meanAngleD(#))
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MEANANGD subroutine─────────────────*/
meanAngleD:   procedure;  arg x;  _sin=0;  _cos=0
numeric digits $d()+$d()%4
n=words(x);                            do j=1 for n
                                       xr = d2r(d2d(word(x,j)))
                                       _sin = _sin + sin(xr)
                                       _cos = _cos + cos(xr)
                                       end   /*j*/
return r2d(atan2(_sin/n, _cos/n))
/*═════════════════════════════general 1-line subs══════════════════════*/
/*The 1-line subs were broken up into multiple lines for easier reading.*/
d2d:    return arg(1)//360
d2r:    return r2r(d2d(arg(1))/180*pi())
r2d:    return d2d((r2r(arg(1))/pi())*180)
r2r:    return arg(1)//(2*pi())
p:      return word(arg(1),1)
$d:     return p(arg(1) digits())
$fuzz:  return min(arg(1),max(1,$d()-arg(2)))
showit: procedure expose showDigs;  numeric digits showDigs;  arg a,ma
        return left('angles='a,30) 'mean angle=' format(ma,,showDigs,0)/1
acos:   procedure; arg x; if x<-1 | x>1 then call $81r -1,1,x,"ACOS"
        return .5*pi() - asin(x)   /* $81r subroutine not included here.*/
atan:   if abs(arg(1))=1 then return pi()*.25*sign(arg(1))
        return asin(arg(1) / sqrt(1+arg(1)**2))
asin:   procedure;   arg x;   if x<-1 | x>1 then call $81r -1,1,x,"ASIN"
        s=x*x;   if abs(x)>=.7 then return sign(x)*acos(sqrt(1-s),'-ASIN')
        z=x;  o=x;  p=z;        do j=2 by 2;  o=o*s*(j-1)/j;  z=z+o/(j+1)
        if z=p then leave;  p=z;  end;     return z
atan2:  procedure;  arg y,x;  pi=pi();  s=sign(y)
        select;  when x=0 then z=s*pi*.5;  when x<0 then if y=0 then z=pi
        else z=s*(pi-abs(atan(y/x)));otherwise z=s*atan(y/x);end; return z
cos:    procedure;  arg x;  x=r2r(x);  a=abs(x);  numeric fuzz $fuzz(5,3)
        if a=0 then return 1;   if a=pi() then return -1
        if a=pi()*.5 | a=pi()*1.5 then return 0;if a=pi()/3 then return .5
        if a=2*pi()/3 then return -.5;   return .sincos(1,1,-1)
sin:    procedure;  arg x;  x=r2r(x);  numeric fuzz $fuzz(5,3)
        if x=pi()*.5 then return 1;   if x==pi()*1.5 then return -1
        if abs(x)=pi() | x=0 then return 0;   return .sincos(x,x,1)
.sincos: parse arg z,_,i; x=x*x; p=z; do k=2 by 2; _=-_*x/(k*(k+i)); z=z+_
        if z=p then leave; p=z; end; return z
sqrt:   procedure; parse arg x; if x=0 then return 0; d=digits()
        numeric digits 11; g=.sqrtGuess(); do j=0 while p>9;m.j=p; p=p%2+1
        end;     do k=j+5 to 0 by -1;  if m.k>11 then numeric digits m.k
        g=.5*(g+x/g);  end;      numeric digits d;  return g/1
.sqrtGuess: if x<0 then call er 02,x p($.ff 'SQRT') "negative"
        /*The above IF statement was left here to show checking for x<0.*/
        numeric form;  m.=11;  p=d+d%4+2
        parse value format(x,2,1,,0) 'E0' with g 'E' _ .;return g*.5'E'_%2
pi:     return ,
3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148
