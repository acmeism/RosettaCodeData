/*REXX program does numerical integration using an N-point Gauss─Legendre quadrature rule.   */
pi=pi();     digs=length(pi)-1;       numeric digits digs;            reps=digs%2
!.=.;        b=3;         a=-b;       bma=b-a;       bmaH=bma/2;      tiny='1e-'digs
trueV=exp(b)-exp(a);                  bpa=b+a;       bpaH=bpa/2
say ' step '  center("iterative value",digs+3)    '  difference'                   /*show hdr*/
sep='──────'  copies("─"              ,digs+3)    '─────────────';    say sep      /*  "  sep*/

  do #=1  until dif>0;   p0z=1;   p0.1=1;   p1z=2;   p1.1=1;   p1.2=0;   ##=#+.5;   r.=0

  /*█*/    do k=2  to #;  km=k-1;   do y=1  for p1z;   T.y=p1.y;             end  /*y*/
  /*█*/    T.y=0;  TT.=0;           do L=1  for p0z;   _=L+2;  TT._=p0.L;    end  /*L*/
  /*█*/
  /*█*/    kkm=k+km;      do j=1  for p1z+1;    T.j=(kkm*T.j-km*TT.j)/k ;    end  /*j*/
  /*█*/    p0z=p1z;       do n=1  for p0z;      p0.n=p1.n               ;    end  /*n*/
  /*█*/    p1z=p1z+1;     do p=1  for p1z;      p1.p= T.p               ;    end  /*p*/
  /*█*/    end   /*k*/

                 /*▓*/        do !=1  for #;       x=cos( pi * (! - .25)  /  ## )
                 /*▓*/
                 /*▓*/                    /*░*/   do reps  until abs(dx) <= tiny
                 /*▓*/                    /*░*/   f=p1.1;   df=0;           do u=2  to p1z
                 /*▓*/                    /*░*/                             df=f   + x*df
                 /*▓*/                    /*░*/                             f=p1.u + x*f
                 /*▓*/                    /*░*/                             end   /*u*/
                 /*▓*/                    /*░*/   dx=f/df;  x=x-dx
                 /*▓*/                    /*░*/   end   /*reps ···*/
                 /*▓*/        r.1.!=x
                 /*▓*/        r.2.!=2 / ((1 - x**2) * df**2)
                 /*▓*/        end   /*!*/
  $=0
                 /*▒*/    do m=1  for #;  $=$ + r.2.m * exp(bpaH + r.1.m*bmaH);  end  /*m*/
  z=bmaH*$                                                       /*calculate target value (Z)*/
  dif=z-trueV;            z=format(z, 3, digs-2)                 /*    "     difference.     */
  Ndif=translate( format(dif, 3, 4, 2, 0),  'e',  "E")
  if #\==1  then  say center(#, 6)  z' '  Ndif               /*don't display if not computed.*/
  end   /*#*/

say sep;  xdif=compare(strip(z), trueV);                       say right("↑", 6+1+xdif)
say  left('', 6+1)       trueV         " {exact value}";       say
say 'Using '      digs      " digit precision, the" ,
    'N-point Gauss─Legendre quadrature (GLQ) had an accuracy of '      xdif-2       " digits."
exit                                                  /*stick a fork in it,  we're all done. */
/*───────────────────────────────────────────────────────────────────────────────────────────*/
e:   return 2.718281828459045235360287471352662497757247093699959574966967627724076630353547595
pi:  return 3.141592653589793238462643383279502884197169399375105820974944592307816406286286209
/*───────────────────────────────────────────────────────────────────────────────────────────*/
cos: procedure  expose !.; parse arg x;   if !.x\==.  then return !.x;  _=1;   z=1;    y=x*x
                do k=2  by 2  until p==z; p=z; _=-_*y/(k*(k-1)); z=z+_; end;   !.x=z;  return z
/*───────────────────────────────────────────────────────────────────────────────────────────*/
exp: procedure; parse arg x;  ix=x % 1;           if abs(x-ix) > .5  then ix=ix + sign(x)
                x=x-ix;  z=1;  _=1;       do j=1  until  p==z;   p=z;   _=_*x/j;   z=z+_;   end
                if z\==0   then z=z * e()**ix;                          return z
