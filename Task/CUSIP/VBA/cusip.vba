Private Function Cusip_Check_Digit(s As Variant) As Integer
    Dim Sum As Integer, c As String, v As Integer
    For i = 1 To 8
        c = Mid(s, i, 1)
        If IsNumeric(c) Then
            v = Val(c)
        Else
            Select Case c
                Case "a" To "z"
                    v = Asc(c) - Asc("a") + 10
                Case "A" To "Z"
                    v = Asc(c) - Asc("A") + 10
                Case "*"
                    v = 36
                Case "@"
                    v = 37
                Case "#"
                    v = 38
                Case Else
                    Debug.Print "not expected"
            End Select
        End If
        If i Mod 2 = 0 Then v = v * 2
        Sum = Sum + Int(v \ 10) + v Mod 10
    Next i
    Cusip_Check_Digit = (10 - (Sum Mod 10)) Mod 10
End Function
