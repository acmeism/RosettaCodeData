Function isPrime(n As Uinteger) As Boolean
    If n Mod 2 = 0 Then Return false
    For i As Uinteger = 3 To Int(Sqr(n))+1 Step 2
        If n Mod i = 0 Then Return false
    Next i
    Return true
End Function

Function Totient(n As Uinteger) As Integer
    Dim As Uinteger tot = n, i = 2
    While i*i <= n
        If n Mod i = 0 Then
            Do
                n /= i
            Loop Until n Mod i <> 0
            tot -= tot/i
        End If
        i += Iif(i = 2, 1, 2)
    Wend
    If n > 1 Then tot -= tot/n
    Return tot
End Function

Dim As Uinteger n, limit = 1e6, sumPhi = 0
Dim As Uinteger a(limit)
For n = 1 To limit
    sumPhi += Totient(n)
    a(n) = Iif(isPrime(n), a(n-1), n * (n - 1) / 2 + 1 - sumPhi)
Next n

Print "Number of pairs with common factors - first one hundred terms:"
Dim As Uinteger j, count = 0
For j = 1 To 100
    count += 1
    Print Using "  ##,###"; a(j);
    If(count Mod 10) = 0 Then Print
Next j

Print !"\nThe 1st term: "; a(1)
Print "The 10th term: "; a(10)
Print "The 100th term: "; a(1e2)
Print "The 1,000th term: "; a(1e3)
Print "The 10,000th term: "; a(1e4)
Print "The 100,000th term: "; a(1e5)
Print "The 1,000,000th term: "; a(1e6)
Sleep
