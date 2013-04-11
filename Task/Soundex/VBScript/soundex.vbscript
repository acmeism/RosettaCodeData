Function getCode(c)
    Select Case c
        Case "B", "F", "P", "V"
            getCode = "1"
        Case "C", "G", "J", "K", "Q", "S", "X", "Z"
            getCode = "2"
        Case "D", "T"
            getCode = "3"
        Case "L"
            getCode = "4"
        Case "M", "N"
            getCode = "5"
        Case "R"
            getCode = "6"
    End Select
End Function

Function soundex(s)
    Dim code, previous
    code = UCase(Mid(s, 1, 1))
    previous = 7
    For i = 2 to (Len(s) + 1)
        current = getCode(UCase(Mid(s, i, 1)))
        If Len(current) > 0 And current <> previous Then
            code = code & current
        End If
        previous = current
    Next
    soundex = Mid(code, 1, 4)
    If Len(code) < 4 Then
        soundex = soundex & String(4 - Len(code), "0")
    End If
End Function
