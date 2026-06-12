Function HasZero(n As Uinteger) As Boolean
    Return Iif(Instr(Str(n), "0"), True, False)
End Function

Function DecDigits(n As Uinteger) As Uinteger
    Dim As Integer t, m = 1111111111
    Do
        t = n - m
        m /= 10
    Loop Until t >= 0
    Return t
End Function

Dim As Uinteger n = 1, c = 0
Dim As Uinteger n2, m, m2
Do
    n2 = n*n
    If Not HasZero(n2) Then
        m2 = DecDigits(n2)
        m = Sqr(m2)
        If m*m = m2 Then
            Print n2 & "  ";
            c += 1
        End If
    End If
    n += 1
Loop Until c >= 7

Sleep
