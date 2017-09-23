/*REXX program solves the problem of Apollonius, named after the Greek Apollonius of    */
/*────────────────────────────────────── Perga [Pergæus]   (circa 262 BCE ──► 190 BCE). */
numeric digits 15;        c1.x=0;     c1.y=0;     c1.r=1
                          c2.x=4;     c2.y=0;     c2.r=1
                          c3.x=2;     c3.y=4;     c3.r=2
call tell  'external tangent:   ',     Apollonius( 1,  1,  1)
call tell  'internal tangent:   ',     Apollonius(-1, -1, -1)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Apollonius: parse arg s1,s2,s3                   /*could be internal or external tangent*/
      d=digits();         numeric digits d*3     /*reduce rounding,  use thrice digits. */
      x1=c1.x;            x2=c2.x;          x3=c3.x
      y1=c1.y;            y2=c2.y;          y3=c3.y
      r1=c1.r;            r2=c2.r;          r3=c3.r
      va=2*x2  - 2*x1;                      vb=2*y2 - 2*y1
      vc=x1**2 - x2**2 + y1**2 - y2**2 - r1**2 + r2**2
      vd=2*s2*r2 - 2*s1*r1;                 ve=2*x3 - 2*x2;    vf=2*y3    - 2*y2
      vg=x2**2 - x3**2 + y2**2 - y3**2 - r2**2 + r3**2;        vh=2*s3*r3 - 2*s2*r2
      vj=vb/va;           vk=vc/va;         vm=vd/va;          vn=vf/ve   - vj
      vp=vg/ve - vk;      vr=vh/ve - vm;    p =-vp/vn;         q =vr/vn
      m=-vj*p  - vk;      n=vm - vj*q;      a=n**2 + q**2 - 1
      b=2*m*n  - 2*n*x1 + 2*p*q - 2*q*y1 + 2*s1*r1
      c=x1**2  + m**2 - 2*m*x1 + p**2 + y1**2 - 2*p*y1 - r1**2
      _=b**2   - 4*a*c;   $r=(-b - sqrt(_)) / (a+a);           $x=m + n*$r;    $y=p + q*$r
      numeric digits d;   return  $x  $y  $r     /*return with three arguments.         */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  h=d+6;  numeric digits
      m.=9; numeric form; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .; g=g*.5'e'_%2
                  do j=0  while h>9;      m.j=h;               h=h%2 + 1;       end  /*j*/
                  do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g) * .5;  end  /*k*/
      return g
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: parse arg _,a b c; w=digits()+4; say _ left(a/1,w%2) left(b/1,w) left(c/1,w); return
