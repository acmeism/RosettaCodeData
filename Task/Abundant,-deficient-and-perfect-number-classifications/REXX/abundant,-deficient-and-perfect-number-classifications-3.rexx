Call time 'R'
cnt.=0
Do x=1 To 20000
  pd=proper_divisors(x)
  sumpd=sum(pd)
  Select
    When x<sumpd Then cnt.abundant =cnt.abundant +1
    When x=sumpd Then cnt.perfect  =cnt.perfect  +1
    Otherwise         cnt.deficient=cnt.deficient+1
    End
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

Say 'In the range 1 - 20000'
Say format(cnt.abundant ,5) 'numbers are abundant  '
Say format(cnt.perfect  ,5) 'numbers are perfect   '
Say format(cnt.deficient,5) 'numbers are deficient '
Say time('E') 'seconds elapsed'
Exit

proper_divisors: Procedure
Parse Arg n
Pd=''
If n=1 Then Return ''
If n//2=1 Then  /* odd number  */
  delta=2
Else            /* even number */
  delta=1
Do d=1 To n%2 By delta
  If n//d=0 Then
    pd=pd d
  End
Return space(pd)

sum: Procedure
Parse Arg list
sum=0
Do i=1 To words(list)
  sum=sum+word(list,i)
  End
Return sum
