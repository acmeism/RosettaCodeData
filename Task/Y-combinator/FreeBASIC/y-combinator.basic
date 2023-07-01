Function Y(f As String) As String
    Y = f
End Function

Function fib(n As Long) As Long
    Dim As Long n1 = 0, n2 = 1, k, sum
    For k = 1 To Abs(n)
        sum = n1 + n2
        n1 = n2
        n2 = sum
    Next k
    Return Iif(n < 0, (n1 * ((-1) ^ ((-n)+1))), n1)
End Function

Function fac(n As Long) As Long
    Dim As Long r = 1, i
    For i = 2 To n
        r *= i
    Next i
    Return r
End Function

Function execute(s As String, n As Integer) As Long
    Return Iif (s = "fac", fac(n), fib(n))
End Function

Sub test(nombre As String)
    Dim f As String: f = Y(nombre)
    Print !"\n"; f; ":";
    For i As Integer = 1 To 10
        Print execute(f, i);
    Next i
End Sub

test("fac")
test("fib")
Sleep
