Function StripChars(stString As String, stStripChars As String, Optional bSpace As Boolean)
Dim i As Integer, stReplace As String
    If bSpace = True Then
        stReplace = " "
    Else
        stReplace = ""
    End If
    For i = 1 To Len(stStripChars)
        stString = Replace(stString, Mid(stStripChars, i, 1), stReplace)
    Next i
    StripChars = stString
End Function
