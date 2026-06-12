/* REXX  Compute and show Inconsummate numbers in base 10 */
sieveSize=10000
maximum  =sieveSize*length(sieveSize)*9
list.=''
Call createIsConsummate
Say 'The first 50 inconsummate numbers in base 10:'
l=''
show=0
Do n=1 To maximum
  If isconsummate.n=0 Then Do
    show+=1
    If show<=50 Then Do
      l=l right(n,3)
      If show//10=0 Then Do
        Say substr(l,2)
        l=''
        End
      End
    If show=1000 Then Do
      Say ''
      Say 'The 1000th inconsummate number is' n
      Leave
      End
    End
  End
Exit

createIsConsummate:
  isConsummate.=0
  Do n=1 To maximum
    digitalSum = digitalSum(n);
    If n//digitalSum=0 Then Do
      quotient=n%digitalsum
      If quotient<=sievesize Then Do
        isConsummate.quotient=1
     -- list.quotient=list.quotient n
        End
      End
    End
  Return

digitalsum: Procedure
  Parse Arg number
  sum=0
  Do while number>''
    Parse Var number c +1 number
    sum+=c
    End
  Return sum
