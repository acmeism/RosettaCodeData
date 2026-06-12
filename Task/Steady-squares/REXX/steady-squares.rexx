/* REXX */
Numeric Digits 50
Call time 'R'
n=1000000000
Say 'Steady squares below' n
Do i=1 To n
  c=right(i,1)
  If pos(c,'156')>0 Then Do
    i2=i*i
    If right(i2,length(i))=i Then
      Say right(i,length(n)) i2
    End
  End
Say time('E')
