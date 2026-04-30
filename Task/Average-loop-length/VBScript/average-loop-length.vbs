Const MAX = 20
Const ITER = 100000

Function expected(n)
  Dim sum
  ni=n
  For i = 1 To n
    sum = sum + fact(n) / ni / fact(n-i)
    ni=ni*n
  Next
  expected = sum
End Function

Function test(n )
  Dim coun,x,bits
  For i = 1 To ITER
    x = 1
    bits = 0
    Do While Not bits And x
      count = count + 1
      bits = bits Or x
      x =shift(Int(n * Rnd()))
    Loop
  Next
  test = count / ITER
End Function

'VBScript formats numbers but does'nt align them!
function rf(v,n,s) rf=right(string(n,s)& v,n):end function

'some precalculations to speed things up...
dim fact(20),shift(20)
fact(0)=1:shift(0)=1
for i=1 to 20
  fact(i)=i*fact(i-1)
  shift(i)=2*shift(i-1)
next

Dim n
Wscript.echo "For " & ITER &" iterations"
Wscript.Echo " n     avg.     exp.   (error%)"
Wscript.Echo "==   ======   ======  =========="
For n = 1 To MAX
  av = test(n)
  ex = expected(n)
  Wscript.Echo rf(n,2," ")& "  "& rf(formatnumber(av, 4),7," ") & "   "& _
  rf(formatnumber(ex,4),6," ")& "  ("& rf(Formatpercent(1 - av / ex,4),8," ") & ")"
Next
