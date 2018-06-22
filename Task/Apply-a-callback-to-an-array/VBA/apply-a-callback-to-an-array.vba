Option Explicit

Sub Main()
Dim arr, i
    'init
    arr = Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

    'Loop and apply a function (Fibonacci) to each element
    For i = LBound(arr) To UBound(arr): arr(i) = Fibonacci(arr(i)): Next

    'return
    Debug.Print Join(arr, ", ")
End Sub

Private Function Fibonacci(N) As Variant
    If N <= 1 Then
        Fibonacci = N
    Else
        Fibonacci = Fibonacci(N - 1) + Fibonacci(N - 2)
    End If
End Function
