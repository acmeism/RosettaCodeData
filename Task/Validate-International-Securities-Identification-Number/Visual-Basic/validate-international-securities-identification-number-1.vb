Function IsValidISIN(ByVal ISIN As String) As Boolean
Dim s As String, c As String
Dim i As Long
  If Len(ISIN) = 12 Then
    For i = 1 To Len(ISIN)
      c = UCase$(Mid(ISIN, i, 1))
        Select Case c
        Case "A" To "Z"
          If i = 12 Then Exit Function
          s = s & CStr(Asc(c) - 55)
        Case "0" To "9"
          If i < 3 Then Exit Function
          s = s & c
        Case Else
          Exit Function
        End Select
   Next i
  IsValidISIN = LuhnCheckPassed(s)
  End If
End Function
