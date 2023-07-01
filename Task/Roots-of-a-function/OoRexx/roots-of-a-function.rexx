/* REXX  program to solve a cubic polynom equation
a*x**3+b*x**2+c*x+d =(x-x1)*(x-x2)*(x-x3)
*/
Numeric Digits 16
pi3=Rxcalcpi()/3
Parse Value '1 -3 2 0' with a b c d
p=3*a*c-b**2
q=2*b**3-9*a*b*c+27*a**2*d
det=q**2+4*p**3
say 'p='p
say 'q='q
Say 'det='det
If det<0 Then Do
  phi=Rxcalcarccos(-q/(2*rxCalcsqrt(-p**3)),16,'R')
  Say 'phi='phi
  phi3=phi/3
  y1=rxCalcsqrt(-p)*2*Rxcalccos(phi3,16,'R')
  y2=rxCalcsqrt(-p)*2*Rxcalccos(phi3+2*pi3,16,'R')
  y3=rxCalcsqrt(-p)*2*Rxcalccos(phi3+4*pi3,16,'R')
  End
Else Do
  t=q**2+4*p**3
  tu=-4*q+4*rxCalcsqrt(t)
  tv=-4*q-4*rxCalcsqrt(t)
  u=qroot(tu)/2
  v=qroot(tv)/2
  y1=u+v
  y2=-(u+v)/2 (u+v)/2*rxCalcsqrt(3)
  y3=-(u+v)/2 (-(u+v)/2*rxCalcsqrt(3))
  End
say 'y1='y1
say 'y2='y2
say 'y3='y3
x1=y2x(y1)
x2=y2x(y2)
x3=y2x(y3)
Say 'x1='x1
Say 'x2='x2
Say 'x3='x3
Exit

qroot: Procedure
Parse Arg a
return sign(a)*rxcalcpower(abs(a),1/3,16)

y2x: Procedure Expose a b
Parse Arg real imag
xr=(real-b)/(3*a)
If imag<>'' Then Do
  xi=(imag-b)/(3*a)
  Return xr xi'i'
  End
Else
  Return xr
::requires 'rxmath' LIBRARY
