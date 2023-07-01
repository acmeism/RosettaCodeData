Function getSedolCheckDigit(Input1)
    Dim mult(6) As Integer
    mult(1) = 1: mult(2) = 3: mult(3) = 1
    mult(4) = 7: mult(5) = 3: mult(6) = 9
    If Len(Input1) <> 6 Then
        getSedolCheckDigit = "Six chars only please"
        Exit Function
    End If
    Input1 = UCase(Input1)
    Total = 0
    For i = 1 To 6
        s1 = Mid(Input1, i, 1)
        If (s1 = "A") Or (s1 = "E") Or (s1 = "I") Or (s1 = "O") Or (s1 = "U") Then
                getSedolCheckDigit = "No vowels"
                Exit Function
        End If
        If (Asc(s1) >= 48) And (Asc(s1) <= 57) Then
                Total = Total + Val(s1) * mult(i)
        Else
                Total = Total + (Asc(s1) - 55) * mult(i)
        End If

    Next i
    getSedolCheckDigit = Input1 + CStr((10 - (Total Mod 10)) Mod 10)

End Function
