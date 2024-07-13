Dim As String argV(1 To 5)
Dim Shared As String t()

Sub Split (cadena As String, t() As String, sep As String = " ")
    Dim As Integer i, j = 0
    Dim As String word = ""
    For i = 1 To Len(cadena)
        If Mid(cadena, i, 1) <> sep Then
            word &= Mid(cadena, i, 1)
        Else
            Redim Preserve t(j)
            t(j) = word
            word = ""
            j += 1
        End If
    Next i
    If word <> "" Then
        Redim Preserve t(j)
        t(j) = word
    End If
End Sub

Split(Command, t())

#ifdef __FB_WIN32__
    If Ubound(t) <> 3 Then
        Print "Usage: "; Command(0); " <Followed by level, id, source string and description>"
    Else
        For i As Integer = 1 To 4
            argV(i) = t(i-1)
        Next i
        Shell "EventCreate /t " & argV(1) & " /id " & argV(2) & " /l APPLICATION /so " & argV(3) & " /d """ & argV(4) & """"
    End If
#else
    Print "Not implemented for *nix, only Windows."
#endif
