/* REXX ---------------------------------------------------------------
* Test for McCormick function
*--------------------------------------------------------------------*/
Numeric Digits 16
Parse Value '-.5 -1.5 1' With x y d
fmin=1e9
Call refine x,y
Do r=1 To 10
  d=d/5
  Call refine xmin,ymin
  End
Say 'which is better (less) than'
Say '        f(-.54719,-1.54719)='f(-.54719,-1.54719)
Say 'and differs from published  -1.9133'
Exit

refine:
Parse Arg xx,yy
Do x=xx-d To xx+d By d/2
  Do y=yy-d To yy+d By d/2
    f=f(x,y)
    If f<fmin Then Do
      Say x y f
      fmin=f
      xmin=x
      ymin=y
      End
    End
  End
Return

f:
Parse Arg x,y
res=rxcalcsin(x+y,16,'R')+(x-y)**2-1.5*x+2.5*y+1
Return res
::requires rxmath library
