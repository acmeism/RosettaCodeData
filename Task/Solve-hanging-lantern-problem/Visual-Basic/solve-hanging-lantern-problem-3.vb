Function getLantern(arr() As Integer) As Integer
    Dim tot As Integer, res As Integer
    Dim i As Integer
    For i = 1 To n
        tot = tot + arr(i)
    Next i
    res = factorial(tot)
    For i = 1 To n
        res = res / factorial(arr(i))
    Next i
    getLantern = res
End Function

Function factorial(num As Integer) As Integer
    Dim i As Integer
    factorial = 1
    For i = 2 To n
        factorial = factorial * i
    Next i
End Function
