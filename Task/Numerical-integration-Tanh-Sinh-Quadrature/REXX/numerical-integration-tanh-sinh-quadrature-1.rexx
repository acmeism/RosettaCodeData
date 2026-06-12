-- 24 Aug 2025
include Setting
arg digs
if digs = '' then
   digs=9
numeric digits digs

say 'NUMERICAL INTEGRATION: TANH-SINH DOUBLE EXPONENTIATION'
say version
say
w=Digits()+2
say Left('Function',10) Left('Range',w+4) 'St',
    Left('Result',w) Left('Should be',w) Left(' Error',w)
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
call Task 'x',          0, 10,     10**2/2
call Task 'x**3',       0, 10,     10**4/4
call Task '1/x',        1, 10,     Ln(10)/1
call Task '4/(x**2+1)', 0, 1,      Pi()/1
call Task 'Gamma(x)',   1, 10,     164960.329
call Timer
exit

Task:
procedure expose Memo.
arg ff,aa,bb,true
w=Digits()+2
do steps = 1 to 6
   res=TanhSinh(ff,aa,bb,steps); diff=res-true
   say Left(ff,10) Left(aa '-' bb,w+4) Right(steps,2),
       Left(Std(res),w) Left(true/1,w) Format(diff,2,4,,0)
end
say
return

TanhSinh:
procedure expose Memo.
arg ff,aa,bb,steps
h=0.1; h0=(bb-aa)/2; h1=(aa+bb)/2
do k = 1 to steps
   n=2**k-1; ss=0
   do i = -n to n
      t=i*h
      sh=Sinh(t); ch=Cosh(t); th=Tanh(HalfPi()*sh)
      dx=(HalfPi()*ch)/((Cosh(HalfPi()*sh))**2)
      xi=h1+h0*th; wt=h*dx
      ss=ss+Eval(ff,xi)*wt
   end
   rr=h0*ss
end
return rr

include Math
