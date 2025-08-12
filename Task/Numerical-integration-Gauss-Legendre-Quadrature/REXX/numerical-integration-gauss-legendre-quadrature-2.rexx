-- 28 Jul 2025
include Settings
arg digs
if digs = '' then
   digs=16
numeric digits digs

say 'NUMERICAL INTEGRATION: GAUSS-LEGENDRE QUADRATURE'
say version
say
w=Digits()+2
say Left('Function',10) Left('Range',w+4) ' N',
    Left('Result',w) Left('True',w) Left(' Error',w)
say
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
call Task 'Exp(x)',    -3, 3,      Exp(3)-Exp(-3)
call Task 'Gamma(x)',   1, 8,      2603.238829328642145
call Timer
exit

Task:
procedure expose Memo.
arg ff,aa,bb,true
w=Digits()+2
do nn = 1 to 20
   res=GaussQuad(ff,aa,bb,nn); diff=res-true
   say Left(ff,10) Left(aa '-' bb,w+4) Right(nn,2),
       Left(Std(res),w) Left(true/1,w) Format(diff,2,4,,0)
end
say
return

GaussQuad:
procedure expose Memo.
-- Gaussion-Legendre quadrature on function f in range a...b taking n points
arg ff,aa,bb,nn
-- Legendre polynomials
p0=1; poly1.1=1; p1=2; poly2.1=1; poly2.2=0
do i = 2 to nn
   work1.0=p1+1
   do j = 1 to p1
      work1.j=poly2.j
   end
   work1.j=0; work2.0=p0+2; work2.1=0; work2.2=0
   do j = 1 to p0
      j2=j+2; work2.j2=poly1.j
   end
   do j = 1 to work1.0
      work1.j=((2*i-1)*work1.j-(i-1)*work2.j)/i
   end
   p0=p1
   do j = 1 to p0
      poly1.j=poly2.j
   end
   p1=work1.0
   do j = 1 to p1
      poly2.j=work1.j
   end
end
-- Roots and weights
eps=1/10**Digits()
root.=0
do i = 1 to nn
   x=Cos(Pi()*(i-0.25)/(nn+0.5))
   do 10 until Abs(dx) < eps
      f=poly2.1; df=0
      do k = 2 to p1
         df=f+x*df; f=poly2.k+x*f
      end
      dx=f/df; x=x-dx
   end
   root.1.i=x; root.2.i=2/((1-x*x)*df*df)
end
-- Quadrature
bp=0.5*(bb+aa); bm=0.5*(bb-aa); zz=0
do i = 1 to nn
   zz=zz+root.2.i*Eval(ff,bp+root.1.i*bm)
end
return bm*zz

include Math
