Public Function LuhnCheckPassed(ByVal dgts As String) As Boolean
Dim i As Long, s As Long, s1 As Long
  dgts = VBA.StrReverse(dgts)
    For i = 1 To Len(dgts) Step 2
        s = s + CInt(Mid$(dgts, i, 1))
    Next i
    For i = 2 To Len(dgts) Step 2
        s1 = 2 * (CInt(Mid$(dgts, i, 1)))
        If s1 >= 10 Then
            s = s - 9
        End If
        s = s + s1
    Next i
  LuhnCheckPassed = Not CBool(s Mod 10)
End Function
