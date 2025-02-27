/* REXX */
Numeric Digits 70
Call test 2,2
Call test 10,3
Call test 625,-4
Call test 100.666,47
Call test -256,8
Call test 12345678900098765432100.00987654321000123456789e333,19
Exit
test:
Parse Arg x,n
xa=abs(x)
na=abs(n)
lnx=rxmlog(xa,70)
rt=rxmexp(lnx/na,70)
Numeric Digits 65
result=rt+0
If pos('.',result)>0 Then Do   -- get rid of zeroes in decimals
  Parse Var result int '.' dec
  If dec=0 Then
    result=int
  End
If sign(n)=-1 Then result=1/result
If sign(x)=-1 Then result=result'j'
Say '       x = ' x
Say '    root = ' n
Say '  digits = ' 65
Say '  answer = ' result
Say ''
Return
::REQUIRES rxm.cls
