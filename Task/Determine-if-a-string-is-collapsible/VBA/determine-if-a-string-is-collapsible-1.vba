Function Collapse(strIn As String) As String
Dim i As Long, strOut As String
    If Len(strIn) > 0 Then
        strOut = Mid$(strIn, 1, 1)
        For i = 2 To Len(strIn)
            If Mid$(strIn, i, 1) <> Mid$(strIn, i - 1, 1) Then
                strOut = strOut & Mid$(strIn, i, 1)
            End If
        Next i
    End If
    Collapse = strOut
End Function
