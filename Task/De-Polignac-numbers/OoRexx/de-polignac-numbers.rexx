/* Compute and show de Polignac numbers */
Call time 'R'
count=0
Do n=1 by 2 Until count>=10000
  If isDePolignacNumber(n) Then Do
    count+=1
    Select
      When count<=50 Then
        Call oa
      When wordpos(count,1000 10000)>0 Then
        Say left('The' count'th de Polignac number is:',34) right(n,6)
      Otherwise
        Nop
      End
    End
  End
Say time('E') 'seconds'
Exit

isDePolignacNumber: Procedure
  Parse Arg number
  p=1
  Do While p<=number
    If Prime(number-p) Then
      return 0
    p*=2
    End
  return 1

oa:
/* Output of the first 50 de Polignac numbers (10 per line) */
  If count=1 Then Do
    Say 'The first 50 de Polignac numbers are:'
    ol=''
    End
  ol=ol right(n,4)
  If count//10=0 Then Do
    say ol
    If count=50 Then
      Say ''
    Else
      ol=''
    End
  Return

::REQUIRES math
