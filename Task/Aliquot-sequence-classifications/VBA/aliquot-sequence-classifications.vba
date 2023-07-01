Option Explicit

Private Type Aliquot
   Sequence() As Double
   Classification As String
End Type

Sub Main()
Dim result As Aliquot, i As Long, j As Double, temp As String
'display the classification and sequences of the numbers one to ten inclusive
   For j = 1 To 10
      result = Aliq(j)
      temp = vbNullString
      For i = 0 To UBound(result.Sequence)
         temp = temp & result.Sequence(i) & ", "
      Next i
      Debug.Print "Aliquot seq of " & j & " : " & result.Classification & "   " & Left(temp, Len(temp) - 2)
   Next j
'show the classification and sequences of the following integers, in order:
Dim a
   '15 355 717 786 080 : impossible in VBA ==> out of memory
   a = Array(11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488)
   For j = LBound(a) To UBound(a)
      result = Aliq(CDbl(a(j)))
      temp = vbNullString
      For i = 0 To UBound(result.Sequence)
         temp = temp & result.Sequence(i) & ", "
      Next i
      Debug.Print "Aliquot seq of " & a(j) & " : " & result.Classification & "   " & Left(temp, Len(temp) - 2)
   Next
End Sub

Private Function Aliq(Nb As Double) As Aliquot
Dim s() As Double, i As Long, temp, j As Long, cpt As Long
   temp = Array("non-terminating", "Terminate", "Perfect", "Amicable", "Sociable", "Aspiring", "Cyclic")
   ReDim s(0)
   s(0) = Nb
   For i = 1 To 15
      cpt = cpt + 1
      ReDim Preserve s(cpt)
      s(i) = SumPDiv(s(i - 1))
      If s(i) > 140737488355328# Then Exit For
      If s(i) = 0 Then j = 1
      If s(1) = s(0) Then j = 2
      If s(i) = s(0) And i > 1 And i <> 2 Then j = 4
      If s(i) = s(i - 1) And i > 1 Then j = 5
      If i >= 2 Then
         If s(2) = s(0) Then j = 3
         If s(i) = s(i - 2) And i <> 2 Then j = 6
      End If
      If j > 0 Then Exit For
   Next
   Aliq.Classification = temp(j)
   Aliq.Sequence = s
End Function

Private Function SumPDiv(n As Double) As Double
'returns the sum of the Proper divisors of n
Dim j As Long, t As Long
    If n > 1 Then
        For j = 1 To n \ 2
            If n Mod j = 0 Then t = t + j
        Next
    End If
    SumPDiv = t
End Function
