Function pangram2(s As String) As Boolean
    Const sKey As String = "abcdefghijklmnopqrstuvwxyz"
    Dim sLow As String
    Dim i As Integer

    sLow = LCase(s)
    For i = 1 To 26
      If InStr(sLow, Mid(sKey, i, 1)) = 0 Then
        pangram2 = False
        Exit Function
      End If
    Next
    pangram2 = True
End Function
