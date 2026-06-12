Function isPrime(Byval ValorEval As Integer) As Boolean
    If ValorEval <= 1 Then Return False
    For i As Integer = 2 To Int(Sqr(ValorEval))
        If ValorEval Mod i = 0 Then Return False
    Next i
    Return True
End Function

Dim As Integer n = 0, num = 0, suma
print "The first 20 pairs of numbers whose sum is prime:"
Do
    n += 1
    suma = 2*n+1
    If isPrime(suma) Then
        num += 1
        If num < 21 Then
            Print using "## + ## = ##"; n; (n+1); suma
        Else
            Exit Do
        End If
    End If
Loop
Sleep
