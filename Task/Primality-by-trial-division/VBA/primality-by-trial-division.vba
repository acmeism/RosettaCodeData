Option Explicit

Sub FirstTwentyPrimes()
Dim count As Integer, i As Long, t(19) As String
   Do
      i = i + 1
      If IsPrime(i) Then
         t(count) = i
         count = count + 1
      End If
   Loop While count <= UBound(t)
   Debug.Print Join(t, ", ")
End Sub

Function IsPrime(Nb As Long) As Boolean
   If Nb = 2 Then
      IsPrime = True
   ElseIf Nb < 2 Or Nb Mod 2 = 0 Then
      Exit Function
   Else
      Dim i As Long
      For i = 3 To Sqr(Nb) Step 2
         If Nb Mod i = 0 Then Exit Function
      Next
      IsPrime = True
   End If
End Function
