Public Function Fib(n As Integer) As Long
    Dim fib0, fib1, sum As Long
    Dim i As Integer
    fib0 = 0
    fib1 = 1
    For i = 1 To n
        sum = fib0 + fib1
        fib0 = fib1
        fib1 = sum
    Next
    Fib = fib0
End Function
