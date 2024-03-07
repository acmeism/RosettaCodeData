Function is_prime(x As Integer) As Boolean
    If x <= 1 Then Return False
    For i As Integer = 2 To Sqr(x)
        If x Mod i = 0 Then Return False
    Next i
    Return True
End Function

Function satisfies_statement1(s As Integer) As Boolean
    For a As Integer = 2 To s \ 2
        If is_prime(a) And is_prime(s - a) Then Return False
    Next a
    Return True
End Function

Function satisfies_statement2(p As Integer) As Integer
    Dim As Integer i, j
    Dim winner As Integer = 0
    For i = 2 To Sqr(p)
        If p Mod i = 0 Then
            j = p \ i
            If j < 2 Or j > 99 Then Continue For
            If satisfies_statement1(i + j) Then
                If winner Then Return False
                winner = 1
            End If
        End If
    Next i
    Return winner
End Function

Function satisfies_statement3(s As Integer) As Integer
    Dim As Integer a, b
    If Not satisfies_statement1(s) Then Return False
    Dim winner As Integer = 0
    For a = 2 To s \ 2
        b = s - a
        If satisfies_statement2(a * b) Then
            If winner Then Return False
            winner = a
        End If
    Next a
    Return winner
End Function

Dim As Integer s, a
For s = 2 To 100
    a = satisfies_statement3(s)
    If a <> 0 Then
        Print s & " (" & a & "+" & s - a & ")"
    End If
Next s

Sleep
