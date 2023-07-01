/*REXX program shows how to support mathematical functions for vectors using functions. */
       s1 =     11                               /*define the  s1 scalar: eleven        */
       s2 =      2                               /*define the  s2 scalar: two           */
       x  = '(5, 7)'                             /*define the  X  vector: five and seven*/
       y  = '(2, 3)'                             /*define the  Y  vector: two  and three*/
       z  = '(2, 45)'                            /*define vector of length   2  at  45º */
call show  'define a vector (length,ºangle):',     z                ,      Vdef(z)
call show         'addition (vector+vector):',     x      " + "   y ,      Vadd(x, y)
call show      'subtraction (vector-vector):',     x      " - "   y ,      vsub(x, y)
call show   'multiplication (Vector*scalar):',     x      " * "   s1,      Vmul(x, s1)
call show         'division (vector/scalar):',     x      " ÷ "   s2,      Vdiv(x, s2)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$fuzz: return min( arg(1), max(1, digits() - arg(2) ) )
cosD:  return cos( d2r( arg(1) ) )
d2d:   return arg(1) // 360                      /*normalize degrees ──► a unit circle. */
d2r:   return r2r( d2d(arg(1)) * pi() / 180)     /*convert degrees   ──►   radians.     */
pi:    pi=3.14159265358979323846264338327950288419716939937510582;         return pi
r2d:   return d2d( (arg(1)*180 / pi()))          /*convert radians   ──►   degrees.     */
r2r:   return arg(1) // (pi() * 2)               /*normalize radians ──► a unit circle. */
show:  say  right( arg(1), 33)   right( arg(2), 20)      ' ──► '      arg(3);       return
sinD:  return  sin( d2r( d2d( arg(1) ) ) )
V:     return  word( translate( arg(1), , '{[(JI)]}')  0,  1)   /*get the number or zero*/
V$:    parse arg r,c;     _='['r;       if c\=0  then _=_"," c;               return _']'
V#:    a=V(a); b=V(b); c=V(c); d=V(d);  ac=a*c; ad=a*d; bc=b*c; bd=b*d; s=c*c+d*d;  return
Vadd:  procedure; arg a ',' b,c "," d;      call V#;       return V$(a+c,             b+d)
Vsub:  procedure; arg a ',' b,c "," d;      call V#;       return V$(a-c,             b-d)
Vmul:  procedure; arg a ',' b,c "," d;      call V#;       return V$(ac-bd,         bc+ad)
Vdiv:  procedure; arg a ',' b,c "," d;      call V#;       return V$((ac+bd)/s, (bc-ad)/s)
Vdef:  procedure; arg a ',' b,c "," d;      call V#;       return V$(a*sinD(b), a*cosD(b))
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos: procedure; parse arg x;        x=r2r(x);       a=abs(x);    numeric fuzz $fuzz(9, 9)
                if a=pi             then return -1;
                if a=pi*.5 | a=pi*2 then return  0;                   return .sinCos(1,-1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sin: procedure; parse arg x;        x=r2r(x);                    numeric fuzz $fuzz(5, 3)
                if x=pi*.5          then return 1;  if x=pi*1.5  then return -1
                if abs(x)=pi | x=0  then return 0;                    return .sinCos(x,+1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
.sinCos: parse arg z 1 _,i;          q=x*x
           do k=2  by 2  until p=z;  p=z;  _= -_*q / (k*(k+i));  z=z+_;  end;     return z
