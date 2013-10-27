/* REXX ***************************************************************
* 26.07.2913 Walter Pachl
**********************************************************************/
  Numeric Digits 30
  Parse Arg a b c 1 alist
  Select
    When a='' | a='?' Then
      Call exit 'rexx qgl a b c solves a*x**2+b*x+c'
    When words(alist)<>3 Then
      Call exit 'three numbers are required'
    Otherwise
      Nop
    End
  gl=a'*x**2'
  Select
    When b<0 Then gl=gl||b'*x'
    When b>0 Then gl=gl||'+'||b'*x'
    Otherwise Nop
    End
  Select
    When c<0 Then gl=gl||c
    When c>0 Then gl=gl||'+'||c
    Otherwise Nop
    End
  Say gl '= 0'

  d=b**2-4*a*c
  If d<0 Then Do
    dd=sqrt(-d)
    r=-b/(2*a)
    i=dd/(2*a)
    x1=r'+'i'i'
    x2=r'-'i'i'
    End
  Else Do
    dd=sqrt(d)
    x1=(-b+dd)/(2*a)
    x2=(-b-dd)/(2*a)
    End
  Say 'x1='||x1
  Say 'x2='||x2
  Exit
sqrt:
/* REXX ***************************************************************
* EXEC to calculate the square root of x with high precision
**********************************************************************/
  Parse Arg x
  prec=digits()
  prec1=2*prec
  eps=10**(-prec1)
  k = 1
  Numeric Digits prec1
  r0= x
  r = 1
  Do i=1 By 1 Until r=r0 | (abs(r*r-x)<eps)
    r0 = r
    r  = (r + x/r) / 2
    k  = min(prec1,2*k)
    Numeric Digits (k + 5)
    End
  Numeric Digits prec
  Return (r+0)
exit: Say arg(1)
