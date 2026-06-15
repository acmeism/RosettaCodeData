-- 13 Jun 2026
include Setting
numeric digits 4

say 'NUMERICAL INTEGRATION: COMPARE 3 METHODS'
say version
say
do 4
   numeric digits 2*Digits()
   say 'Precision' Digits() 'digits'
   say
   w=Digits()+7
   say Left('Function',23)  Left('Range',8) Left('Method',9),
       Left('Result',w) Left(' Error',8) 'Took'
   say
-- Polynomial
   function='x**3-x**2-x'; primitive='x**4/4-x**3/3-x**2/2'
   call Task function,1,2,primitive
   call Task function,1,20,primitive
-- Reciprocal
   function='1/(x**2+1)'; primitive='arctan(x)'
   call Task function,1,2,primitive
   call Task function,1,20,primitive
-- Basic transcendental
   function='Sin(x)'; primitive='-cos(x)'
   call Task function,1,2,primitive
   call Task function,1,20,primitive
   function='Exp(x)'; primitive='exp(x)'
   call Task function,1,2,primitive
   call Task function,1,20,primitive
   function='Ln(x)'; primitive='x*ln(x)-x'
   call Task function,1,2,primitive
   call Task function,1,20,primitive
-- Formula
   function='x*Exp(x)*Sin(x)'; primitive='exp(x)*(x*sin(x)/2-(x-1)*cos(x)/2)'
   call Task function,1,2,primitive
   call Task function,1,20,primitive
end
call Timer
exit

Task:
procedure expose Glob.
arg ff,aa,bb,prim
eps='1E'||-Digits(); steps=2**20; w=Digits()+7
true=Eval(prim,bb)-Eval(prim,aa)
t=Time('e')
say Left(ff,23) Left(aa '-' bb,8) Left('Should be',9),
    Left(true/1,w)
t=Time('e'); res=Romberg(ff,aa,bb)/1; diff=res-true
say Left(ff,23) Left(aa '-' bb,8) Left('Romberg',9),
    Left(res,w) Left(Format(diff,2,0,,0),8) (Time('e')-t)/1's'
t=Time('e'); res=Gaussian(ff,aa,bb)/1; diff=res-true
say Left(ff,23) Left(aa '-' bb,8) Left('Gaussian',9),
    Left(res,w) Left(Format(diff,2,0,,0),8) (Time('e')-t)/1's'
t=Time('e'); res=TanhSinh(ff,aa,bb)/1; diff=res-true
say Left(ff,23) Left(aa '-' bb,8) Left('TanhSinh',9),
    Left(res,w) Left(Format(diff,2,0,,0),8) (Time('e')-t)/1's'
say
return

include Math
