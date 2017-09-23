/* REXX ---------------------------------------------------------------
* Implementation of http://keisan.casio.com/exec/system/14059932254941
*--------------------------------------------------------------------*/
xl='0 1  2  3  4  5   6   7   8   9  10'
yl='1 6 17 34 57 86 121 162 209 262 321'
n=11
Do i=1 To n
  Parse Var xl x.i xl
  Parse Var yl y.i yl
  End
xm=0
ym=0
x2m=0
x3m=0
x4m=0
xym=0
x2ym=0
Do i=1 To n
  xm=xm+x.i
  ym=ym+y.i
  x2m=x2m+x.i**2
  x3m=x3m+x.i**3
  x4m=x4m+x.i**4
  xym=xym+x.i*y.i
  x2ym=x2ym+(x.i**2)*y.i
  End
xm =xm /n
ym =ym /n
x2m=x2m/n
x3m=x3m/n
x4m=x4m/n
xym=xym/n
x2ym=x2ym/n
Sxx=x2m-xm**2
Sxy=xym-xm*ym
Sxx2=x3m-xm*x2m
Sx2x2=x4m-x2m**2
Sx2y=x2ym-x2m*ym
B=(Sxy*Sx2x2-Sx2y*Sxx2)/(Sxx*Sx2x2-Sxx2**2)
C=(Sx2y*Sxx-Sxy*Sxx2)/(Sxx*Sx2x2-Sxx2**2)
A=ym-B*xm-C*x2m
Say 'y='a'+'||b'*x+'c'*x**2'
Say ' Input  "Approximation"'
Say ' x   y     y1'
Do i=1 To 11
  Say right(x.i,2) right(y.i,3) format(fun(x.i),5,3)
  End
Exit
fun:
  Parse Arg x
  Return a+b*x+c*x**2
