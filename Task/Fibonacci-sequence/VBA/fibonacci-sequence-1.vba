Public Function Fib(ByVal n As Integer) As Variant
    Dim fib0 As Variant, fib1 As Variant, sum As Variant
    Dim i As Integer
    fib0 = 0
    fib1 = 1
    For i = 1 To n
        sum = fib0 + fib1
        fib0 = fib1
        fib1 = sum
    Next i
    Fib = fib0
End Function
