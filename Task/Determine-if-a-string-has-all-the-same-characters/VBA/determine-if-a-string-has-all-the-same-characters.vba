Sub Main_SameCharacters()
Dim arr, i As Integer, respons As Integer
    arr = Array("", "   ", "2", "333", ".55", "tttTTT", "4444 444k", "111111112", " 123")
    For i = LBound(arr) To UBound(arr)
        If SameCharacters(arr(i), respons) Then
            Debug.Print "Analyze : [" & arr(i) & "], lenght " & Len(arr(i)) & " : " & " All characters are the same."
        Else
            Debug.Print "Analyze : [" & arr(i) & "], lenght " & Len(arr(i)) & " : " & " is different at position " & respons & ", character = '" & Mid(arr(i), respons, 1) & "', hexa : (0x" & Hex(Asc(Mid(arr(i), respons, 1))) & ")"
        End If
    Next
End Sub
Function SameCharacters(sTxt, resp As Integer, Optional LowerUpper As Boolean = False) As Boolean
Dim A As String, B As String, i As Integer, temp As Integer
    If Len(sTxt) > 1 Then
        If LowerUpper Then
            SameCharacters = UCase(sTxt) = String$(Len(sTxt), UCase(Left$(sTxt, 1)))
        Else
            SameCharacters = sTxt = String$(Len(sTxt), Left$(sTxt, 1))
        End If
        If Not SameCharacters Then resp = InStr(sTxt, Left$(Replace(sTxt, Left$(sTxt, 1), vbNullString), 1))
    Else
        SameCharacters = True
    End If
End Function
