/*REXX*/

Call time 'R'
Do x=1 To 10
  Say x '->' proper_divisors(x)
  End

hi=1
Do x=1 To 20000
  /* If x//1000=0 Then Say x */
  npd=count_proper_divisors(x)
  Select
    When npd>hi Then Do
      list.npd=x
      hi=npd
      End
    When npd=hi Then
      list.hi=list.hi x
    Otherwise
      Nop
    End
  End

Say hi '->' list.hi

Say ' 166320 ->' count_proper_divisors(166320)
Say '1441440 ->' count_proper_divisors(1441440)

Say time('E') 'seconds elapsed'
Exit

proper_divisors: Procedure
Parse Arg n
If n=1 Then Return ''
pd=''
/* Optimization reduces 37 seconds to 28 seconds */
If n//2=1 Then  /* odd number  */
  delta=2
Else            /* even number */
  delta=1
Do d=1 To n%2 By delta
  If n//d=0 Then
    pd=pd d
  End
Return space(pd)

count_proper_divisors: Procedure
Parse Arg n
Return words(proper_divisors(n))
