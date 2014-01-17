/*REXX pgm does numerical integration using  Gauss-Legendre Quadrature. */
parse arg digs .;  if digs==''  then digs=40  /*assume the DIGS default?*/
numeric digits digs*2+10                      /*use higher working DIGs.*/
pi=pi();  a=-3;  b=3;   bma =b-a;     bpa =b+a;    tiny ='1E-' || (digs*2)
true = exp(b)-exp(a);   bmaH=bma/2;   bpaH=bpa/2;  times= digs%2 + 1
numeric digits digs+10                        /*use lower working DIGITs*/
say 'step' center("iterative value",digs+3)  ' difference '   /*show hdr*/
sep='────' copies('─'              ,digs+3)  '────────────';  say sep

  do step=1  for times;            p0z=1;   p0.1=1;   step_=step+.5
                                   p1z=2;   p1.1=1;   p1.2=0;   r.=0
/*█*/  do k=2  to step;  km=k-1
/*█*/                              do L=1  for p1z;   T.L=p1.L
/*█*/                              end   /*L*/
/*█*/  T.L=0;  TT.=0
/*█*/                              do L=1  for p0z;   L2=L+2;   TT.L2=p0.L
/*█*/                              end   /*L*/
/*█*/
/*█*/                  do j=1  for p1z+1;T.j=((k+km)*T.j-km*TT.j)/k; end  /*j*/
/*█*/  p0z=p1z;        do j=1  for p0z;  p0.j=p1.j                 ; end  /*j*/
/*█*/  p1z=p1z+1;      do j=1  for p1z;  p1.j= T.j                 ; end  /*j*/
/*█*/  end   /*k*/

         /*▓*/         do !=1  for step
         /*▓*/         x=cos(pi*(!-.25)/step_)
         /*▓*/                              do times%2  until abs(dx)<tiny
         /*▓*/                              f=p1.1;  df=0
         /*▓*/                                               do k=2 to p1z
         /*▓*/                                               df=f+x*df
         /*▓*/                                               f=p1.k+x*f
         /*▓*/                                               end   /*k*/
         /*▓*/                              dx=f/df; x=x-dx
         /*▓*/                              end   /*times%2 until···*/
         /*▓*/         r.1.!=x
         /*▓*/         r.2.!=2/((1-x*x)*df*df)
         /*▓*/         end   /*!*/
  sum=0
              /*▒*/    do m=1 for step; sum=sum+r.2.m*exp(bpaH+r.1.m*bmaH)
              /*▒*/    end   /*m*/
  z=bmaH*sum
  say right(step,4) format(z,2,digs) translate(format(z-true,3,4,,0),'e',"E")
  end   /*step*/

say sep;   say left('',4)  true  " {exact}"
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COS subroutine──────────────────────*/
cos: procedure;   x=r2r(arg(1));    _=1;              z=1;        y=x*x
     do k=2  by 2  until p==z; p=z; _=-_*y/(k*(k-1)); z=z+_; end; return z
/*──────────────────────────────────E subroutine──────────────────────────────────────*/
e: return 2.7182818284590452353602874713526624977572470936999595749669676277240766303535
/*──────────────────────────────────EXP subroutine──────────────────────*/
exp: procedure; parse arg x;  ix=x%1;  if abs(x-ix)>.5  then ix=ix+sign(x)
     x=x-ix;  z=1; _=1;     do j=1  until  p==z; p=z; _=_*x/j; z=z+_;  end
     if z\==0   then z=z*e()**ix;        return z
/*──────────────────────────────────PI subroutine──────────────────────────────────────*/
pi: return 3.1415926535897932384626433832795028841971693993751058209749445923078164062862
/*──────────────────────────────────R2R subroutine──────────────────────*/
r2r:   return arg(1)//(2*pi())         /*normalize radians►1 unit circle*/
