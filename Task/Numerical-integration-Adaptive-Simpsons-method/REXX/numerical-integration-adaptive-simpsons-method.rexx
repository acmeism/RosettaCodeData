-- 23 Aug 2025
include Setting
say
arg digs
if digs = '' then
   digs=9
numeric digits digs

say 'NUMERICAL INTEGRATION: ADAPTIVE SIMPSON''S RULE'
say version
say
w=Digits()+2
say Left('Function',11) Left('Method',10) Left('Range',w+4),
    Left('Result',w) Left('Should be',w) Left(' Error',12) 'Took'
say
call Task 'Sin(x)',     0, 1,      -Cos(1)+1
call Task 'Sin(x)',     0, Pi()/1, 2
call Task 'Sin(x)',     0, 10,     -Cos(10)+1
call Task 'Cos(x)',     0, 1,      Sin(1)
call Task 'Cos(x)',     0, Pi()/1, 0
call Task 'Cos(x)',     0, 10,     Sin(10)
call Task 'Tan(x)',     0, 1,      -Ln(Abs(Cos(1)))
call Task 'Tan(x)',     0, Pi()/1, 0
call Task 'x',          0, 10,     10**2/2
call Task 'x**3',       0, 10,     10**4/4
call Task '1/x',        1, 10,     Ln(10)/1
call Task '4/(x**2+1)', 0, 1,      Pi()/1
call Task 'Exp(x)',    -3, 3,      Exp(3)-Exp(-3)
call Task 'Gamma(x)',   1, 2,      0.9227459506806306
call Timer
exit

Task:
procedure expose Memo.
arg ff,aa,bb,true
eps='1E'||-Digits(); depth=20; steps=2**16
w=Digits()+2
t=Time('e'); res=Recursive(ff,aa,bb,eps,depth)/1; diff=res-true
say Left(ff,11) Left('Recursive',10) Left(aa '-' bb,w+4),
    Left(Std(res),w) Left(true/1,w) Left(Format(diff,2,4,,0),12) (Time('e')-t)/1's'
t=Time('e'); res=Simpson(ff,aa,bb,eps,steps)/1; diff=res-true
say Left(ff,11) Left('Simpson',10) Left(aa '-' bb,w+4),
    Left(Std(res),w) Left(true/1,w) Left(Format(diff,2,4,,0),12) (Time('e')-t)/1's'
t=Time('e'); res=Boole(ff,aa,bb,eps,steps)/1; diff=res-true
say Left(ff,11) Left('Boole',10) Left(aa '-' bb,w+4),
    Left(Std(res),w) Left(true/1,w) Left(Format(diff,2,4,,0),12) (Time('e')-t)/1's'
say
return

Recursive:
procedure expose Memo.
arg ff,aa,bb,eps,depth
numeric digits Digits()+3
x=aa; interpret 'fa='ff
x=bb; interpret 'fb='ff
parse value SimpsonRule(ff,aa,fa,bb,fb) with mm fm whole
return RecursiveSimpson(ff,aa,fa,bb,fb,eps,whole,mm,fm,depth)

RecursiveSimpson:
procedure expose Memo.
arg ff,aa,fa,bb,fb,eps,whole,mm,fm,depth
parse value SimpsonRule(ff,aa,fa,mm,fm) with lm flm ll
parse value SimpsonRule(ff,mm,fm,bb,fb) with rm frm rr
delta=ll+rr-whole; eps1=eps/2
if depth < 1 | eps1 = eps | Abs(delta) <= 15*eps then
   return ll+rr+delta/15
else
   return RecursiveSimpson(ff,aa,fa,mm,fm,eps1,ll,lm,flm,depth-1)+,
          RecursiveSimpson(ff,mm,fm,bb,fb,eps1,rr,rm,frm,depth-1)

SimpsonRule:
procedure expose Memo.
arg ff,aa,fa,bb,fb
mm=(aa+bb)/2; x=mm; interpret 'fm='ff
return mm fm ((bb-aa)/6)*(fa+4*fm+fb)

Simpson:
procedure expose Memo.
arg ff,aa,bb,eps,steps
numeric digits Digits()+3
s0=Eval(ff,aa)+Eval(ff,bb); h0=bb-aa
rr=0; st=2
do until Abs(rr-ro) < eps | st > steps
   ro=rr; h=h0/st; s1=0; s2=0
   do n = 1 by 2 to st-1
      s1=s1+Eval(ff,aa+n*h)
   end
   do n = 2 by 2 to st-2
      s2=s2+Eval(ff,aa+n*h)
   end
   rr=(s0+4*s1+2*s2)*h/3; st=2*st
end
return rr

Boole:
procedure expose Memo.
arg ff,aa,bb,eps,steps
numeric digits Digits()+3
s0=7*(Eval(ff,aa)+Eval(ff,bb)); h0=bb-aa
rr=0; st=4
do until Abs(rr-ro) < eps | st > steps
   ro=rr; h=h0/st; s1=0; s2=0; s3=0
   do n = 1 by 2 to st-1
      s1=s1+Eval(ff,aa+n*h)
   end
   do n = 2 by 4 to st-2
      s2=s2+Eval(ff,aa+n*h)
   end
   do n = 4 by 4 to st-4
      s3=s3+Eval(ff,aa+n*h)
   end
   rr=(s0+32*s1+12*s2+14*s3)*2*h/45; st=2*st
end
return rr

include Math
