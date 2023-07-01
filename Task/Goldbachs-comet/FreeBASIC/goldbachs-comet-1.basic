Function isPrime(Byval ValorEval As Uinteger) As Boolean
    If ValorEval <= 1 Then Return False
    For i As Integer = 2 To Int(Sqr(ValorEval))
        If ValorEval Mod i = 0 Then Return False
    Next i
    Return True
End Function

Function g(n As Uinteger) As Uinteger
    Dim As Uinteger i, count = 0
    If (n Mod 2 = 0) Then     'n in goldbach function g(n) must be even
        For i = 2 To (1/2) * n
            If isPrime(i) And isPrime(n - i) Then count += 1
        Next i
    End If
    Return count
End Function

Print "The first 100 G numbers are:"

Dim As Uinteger col = 1
For n As Uinteger = 4 To 202 Step 2
    Print Using "####"; g(n);
    If (col Mod 10 = 0) Then Print
    col += 1
Next n

Print !"\nThe value of G(1000000) is "; g(1000000)
Sleep
