Function gcd(a As Uinteger, b As Uinteger) As Uinteger
    If b = 0 Then Return a Else Return gcd(b, a Mod b)
End Function

Function lcm(a As Ulongint, b As Ulongint) As Ulongint
    Return (a \ gcd(a, b)) * b
End Function

Function isPrime(n As Uinteger) As Boolean
    If n < 2 Then Return False
    If n = 2 Then Return True
    If n Mod 2 = 0 Then Return False
    For i As Uinteger = 3 To Sqr(n) Step 2
        If n Mod i = 0 Then Return False
    Next
    Return True
End Function

Type PrimeFactorization
    factors(1 To 100) As Uinteger
    powers(1 To 100) As Uinteger
    count As Integer
End Type

Function getPrimeFactorization(n As Uinteger) As PrimeFactorization
    Dim As PrimeFactorization result
    result.count = 0
    Dim As Uinteger d = 2
    While d * d <= n
        If n Mod d = 0 Then
            result.count += 1
            result.factors(result.count) = d
            result.powers(result.count) = 0
            While n Mod d = 0
                result.powers(result.count) += 1
                n \= d
            Wend
        End If
        d += 1
    Wend
    If n > 1 Then
        result.count += 1
        result.factors(result.count) = n
        result.powers(result.count) = 1
    End If
    Return result
End Function

Function pisanoPeriod(m As Uinteger) As Uinteger
    Dim As Uinteger i, a = 0, b = 1, c = 1
    For i = 0 To m * m
        c = (a + b) Mod m
        a = b
        b = c
        If a = 0 And b = 1 Then Return i + 1
    Next
    Return 0
End Function

Function pisanoPrime(p As Uinteger, k As Uinteger) As Ulongint
    Return Iif(isPrime(p), pisanoPeriod(p) * p^(k-1), 0)
End Function

Function pisano(m As Uinteger) As Ulongint
    If m = 1 Then Return 1
    Dim As PrimeFactorization pf = getPrimeFactorization(m)
    Dim As Ulongint pi, result = 1
    For i As Integer = 1 To pf.count
        pi = pisanoPrime(pf.factors(i), pf.powers(i))
        result = lcm(result, pi)
    Next
    Return result
End Function

' Main program
Dim As Uinteger p, n, c = 0
Dim As Ulongint pp, ppp

For p = 2 To 14
    pp = pisanoPrime(p, 2)
    If pp > 0 Then Print Using "pisanoPrime(##_, 2) = &"; p; pp
Next p

Print
For p = 2 To 179
    pp = pisanoPrime(p, 1)
    If pp > 0 Then Print Using "pisanoPrime(###_, 1) = &"; p; pp
Next p

Print !"\npisano(n) for integers 'n' from 1 to 180 are:"
For n = 1 To 180
    Print Using "### "; pisano(n);
    c += 1
    If c Mod 15 = 0 Then Print
Next n

Sleep
