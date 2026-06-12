Function isPrime(Byval ValorEval As Integer) As Boolean
    If ValorEval <= 1 Then Return False
    For i As Integer = 2 To Int(Sqr(ValorEval))
        If ValorEval Mod i = 0 Then Return False
    Next i
    Return True
End Function

Dim As Integer m = 0
While True
    m += 1
    If isPrime((2^m)-1) Then Print m
Wend
Sleep
