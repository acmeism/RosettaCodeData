-- 13 Jun 2026
include Setting
arg digs
if digs = '' then
   digs=9
numeric digits digs

say 'NUMERICAL INTEGRATION: ROMBERG INTEGRATION'
say version
say
w=Digits()+2
say Left('Function',10) Left('Range',w+4) 'St',
    Left('Result',w) Left('True',w) Left(' Error',w)
say
call Task 'Exp(x)',    -3, 3,      Exp(3)-Exp(-3)
call Task 'Sin(x)',     0, 1,      -Cos(1)+1
call Task 'Sin(x)',     0, Pi()/1, 2
call Task 'Sin(x)',     0, 10,     -Cos(10)+1
call Task 'Cos(x)',     0, 1,      Sin(1)
call Task 'Cos(x)',     0, Pi()/1, 0
call Task 'Cos(x)',     0, 10,     Sin(10)
call Task 'Tan(x)',     0, 1,      -Ln(Abs(Cos(1)))
call Task 'Tan(x)',     0, Pi()/1, 0
call Task 'Tan(x)',     0, 10,     -Ln(Abs(Cos(10)))
call Task 'x**3',       0, 1,      1/4
call Task '1/x',        1, 100,    Ln(100)/1
call Task 'x',          0, 5000,   12500000
call Task '4/(x**2+1)', 0, 1,      Pi()/1
call Task 'Gamma(x)',   1, 8,      2603.238829328642145
call Timer
exit

Task:
procedure expose Save.
arg ff,aa,bb,true
w=Digits()+2
do steps = 1 to 15
   res=Romberg(ff,aa,bb,steps); diff=res-true
   say Left(ff,10) Left(aa '-' bb,w+4) Right(steps,2),
       Left(Std(res),w) Left(true/1,w) Format(diff,2,4,,0)
end
say
return

Romberg:
procedure expose Save.
arg ff,aa,bb,steps
h0=bb-aa; s0=Eval(ff,aa)+Eval(ff,bb)
Save.0.0=0.5*s0*h0
n=1
do i = 1 to steps
   n=2*n; h=h0/n; s=0.5*s0
   do j = 1 to n-1
      s=s+Eval(ff,aa+j*h)
   end
   f=1; Save.i.0=s*h
   do k = 1 to i
      k1=k-1; r1=Save.i.k1
      i1=i-1; r2=Save.i1.k1
      f=4*f; rr=(f*r1-r2)/(f-1); Save.i.k=rr
   end
end
return rr

include Math
