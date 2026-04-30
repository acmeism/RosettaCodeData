' Abundant odd numbers

Function DivisorSum(ByVal N As Long) As Long
  ' Returns the sum of the proper divisors of N
  Dim Sum As Long, D As Long, OtherD As Long
  Sum = 1
  For D = 2 To Int(Sqr(N))
    If N Mod D = 0 Then
      Sum = Sum + D
      OtherD = N \ D
      If OtherD <> D Then Sum = Sum + OtherD
    End If
  Next D
  DivisorSum = Sum
End Function

Function FormatLong(ByVal Num As Long, L As Integer) As String
  Dim S As String
  S = Trim(Str(Num))
  If Len(S) > L Then
    FormatLong = String(L, "#")
  Else
    FormatLong = Right(String(L, " ") & S, L)
  End If
End Function

Sub AbundantOddMain()
  Dim OddNumber As Long, ACount As Long, DSum As Long
  Dim Found As Boolean
  ' first 25 odd abundant numbers
  OddNumber = 1
  ACount = 0
  DSum = 0
  Debug.Print "The first 25 abundant odd numbers:"
  Do While ACount < 25
    DSum = DivisorSum(OddNumber)
    If DSum > OddNumber Then
      ACount = ACount + 1
      Debug.Print FormatLong(OddNumber, 6) & " proper divisor sum: " & FormatLong(DSum, 6)
    End If
    OddNumber = OddNumber + 2
  Loop
  ' 1000th odd abundant number
  Do While ACount < 1000
    DSum = DivisorSum(OddNumber)
    If DSum > OddNumber Then ACount = ACount + 1
    OddNumber = OddNumber + 2
  Loop
  Debug.Print "1000th abundant odd number:"
  Debug.Print "    " & OddNumber - 2 & " proper divisor sum: " & DSum
  ' first odd abundant number > 1000000000
  OddNumber = 1000000001
  Found = False
  Do Until Found
    DSum = DivisorSum(OddNumber)
    If DSum > OddNumber Then
      Found = True
      Debug.Print "First abundant odd number > 1 000 000 000:"
      Debug.Print "    " & OddNumber & " proper divisor sum: " & DSum
    End If
    OddNumber = OddNumber + 2
  Loop
End Sub
