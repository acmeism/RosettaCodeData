Public Function RepeatStr(aString As String, aNumber As Integer) As String
Dim bString As String

bString = aString
If aNumber > 1 Then
  For i = 2 To aNumber
    bString = bString & aString
  Next i
End If
RepeatStr = bString
End Function
