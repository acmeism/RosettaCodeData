/* REXX */
Numeric Digits 100
count=0
ol=''
Call Time 'R'
Do n=7 by 1 While count<200
  if isDeceptive(n) Then Do
    count+=1
    Call o n
    End
  End
Say ol time('E') 'seconds'
exit

isDeceptive: procedure expose count
  Parse Arg n
  If n//2>0 & n//3>0 & n//5>0 Then Do
    If modulusPower(10,N-1,N)=1 Then Do
      Do divisor=7 By 6 while divisor*divisor<=n
        If n//divisor=0 | n//(divisor+4)=0 Then Do
          Return 1
          End
        End
      End
    Return 0
    End
  Return 0

modulusPower: Procedure
  Parse Arg Base,Exponent,Modulus
  Call dbg 'ModP Base='Base 'Exponent='Exponent 'Modulus='Modulus
  If Modulus=1 Then
    Return 0
  Base=Base//Modulus
  Call dbg 'Base='Base
  res=1
  Do While Exponent>0
    If exponent//2>0 Then Do
      res=res*base//modulus
      Call dbg 'result='res
      End
    Call dbg 'base='base 'modulus='modulus
    base=(base*base)//modulus
    Call dbg 'base='base
    exponent=exponent%2
    Call dbg 'exponent='exponent
    End
  Call dbg 'result='res
  Return res

o:
ol=ol right(arg(1),6)
If count//10=0 Then Do
  Say substr(ol,2)
  ol=''
  End
Return

dbg:
Return
