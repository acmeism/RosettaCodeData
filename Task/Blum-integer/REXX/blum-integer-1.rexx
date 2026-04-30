include Setting

Say Time()
Call Time 'R'
blumCount = 0
blums.=0
lastDigitCounts.=0
Do number=5 By 4 While blumCount < 400000
  Prime=leastPrimeFactor(number)
  If Prime // 4=3 Then Do
    quotient=number / Prime;
    If quotient <> Prime & isPrimeType3(quotient) Then Do
       blumCount+=1
       If blumCount<=50 Then Do
        blums.blumCount=number
        End
      lastdigit=Right(number,1)
      lastDigitCounts.lastdigit+=1
      If blumCount=50 Then Do
        Say "The first 50 Blum integers:"
        Do i=1 To 50
          If Right(i,1)=1 Then
            l=Format(blums.i,3)
          Else
            l=l Format(blums.i,3)
          If i//10=0 Then
            Say l
          End
        Say ''
        End
      Else Do
        If blumCount=26828 | blumCount // 100000 = 0 Then Do
          Say "The " Format(blumCount,7)"th Blum Integer is:" Format(number,7) Time()
          If blumCount=400000 Then Do
            Say ''
            Say "Percent distribution of the first 400000 Blum integers:"
            Do i=0 To 9
              If lastDigitCounts.i>0 Then
                Say Format(lastDigitCounts.i/4000,6,3)'% end in' i
              End
            End
          End
        End
      End
    End
  End
Say Time()
say Time('E') 'seconds'
Exit

isPrimeType3: Procedure expose Memo.
  Parse Arg number
  Return Prime(number) & (number//4=3)

leastPrimeFactor: Procedure expose Memo.
  Parse Arg number
  Return FFactor(number)

include Math
