/*REXX program solves the problem of Apollonius, named after the Greek Apollonius of    */
/*────────────────────────────────────── Perga [Pergæus]   (circa 262 BCE ──► 190 BCE). */
numeric digits 15;                x1= 0;        y1= 0;         r1= 1
                                  x2= 4;        y2= 0;         r2= 1
                                  x3= 2;        y3= 4;         r3= 2
call tell  'external tangent:   ',       Apollonius( 1,  1,  1)
call tell  'internal tangent:   ',       Apollonius(-1, -1, -1)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Apollonius: parse arg s1,s2,s3                   /*could be internal or external tangent*/
      numeric digits digits() * 3                /*reduce rounding with thrice digits.  */
      va= x2*2     - x1*2;                        vb= y2*2 - y1*2
      vc= x1**2    - x2**2 + y1**2 - y2**2 - r1**2 + r2**2
      vd= s2*r2*2  - s1*r1*2;                     ve= x3*2 - x2*2;   vf= y3*2    - y2*2
      vg= x2**2    - x3**2 + y2**2 - y3**2 - r2**2 + r3**2;          vh= s3*r3*2 - s2*r2*2
      vj= vb/va;               vk= vc/va;         vm=  vd/va;        vn= vf/ve   - vj
      vp= vg/ve    - vk;       vr= vh/ve - vm;    p = -vp/vn;        q = vr/vn
      m =  -vj*p   - vk;       n = vm - vj*q
      a =  n**2 + q**2   - 1
      b =  (m*n    - n*x1    + p*q    - q*y1   + s1*r1)  * 2
      c =  x1**2   + y1**2   + m**2   - r1**2  + p**2    - (m*x1 + p*y1)  * 2
                                         $r= (-b - sqrt(b**2 - a*c*4) ) / (a+a)
      return  (m + n*$r)   (p + q*$r)   ($r)                       /*return 3 arguments.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  h=d+6;  numeric digits
      m.=9; numeric form; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .; g=g*.5'e'_%2
         do j=0  while h>9;     m.j=h;              h= h % 2  +  1;  end  /*j*/
         do k=j+5  to 0  by -1; numeric digits m.k; g=(g+x/g) * .5;  end  /*k*/;  return g
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: parse arg _,a b c; w=digits()+4; say _ left(a/1,w%2) left(b/1,w) left(c/1,w); return
