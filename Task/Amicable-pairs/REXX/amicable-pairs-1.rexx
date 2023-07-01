/*REXX*/

Call time 'R'
Do x=1 To 20000
  pd=proper_divisors(x)
  sumpd.x=sum(pd)
  End
Say 'sum(pd) computed in' time('E') 'seconds'
Call time 'R'
Do x=1 To 20000
  /* If x//1000=0 Then Say x time() */
  Do y=x+1 To 20000
    If y=sumpd.x &,
       x=sumpd.y Then
    Say x y 'found after' time('E') 'seconds'
    End
  End
Say time('E') 'seconds total search time'
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
