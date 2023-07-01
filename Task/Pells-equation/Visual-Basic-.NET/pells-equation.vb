Imports System.Numerics

Module Module1
    Sub Fun(ByRef a As BigInteger, ByRef b As BigInteger, c As Integer)
        Dim t As BigInteger = a : a = b : b = b * c + t
    End Sub

    Sub SolvePell(n As Integer, ByRef a As BigInteger, ByRef b As BigInteger)
        Dim x As Integer = Math.Sqrt(n), y As Integer = x, z As Integer = 1, r As Integer = x << 1,
            e1 As BigInteger = 1, e2 As BigInteger = 0, f1 As BigInteger = 0, f2 As BigInteger = 1
        While True
            y = r * z - y : z = (n - y * y) / z : r = (x + y) / z
            Fun(e1, e2, r) : Fun(f1, f2, r) : a = f2 : b = e2 : Fun(b, a, x)
            If a * a - n * b * b = 1 Then Exit Sub
        End While
    End Sub

    Sub Main()
        Dim x As BigInteger, y As BigInteger
        For Each n As Integer In {61, 109, 181, 277}
            SolvePell(n, x, y)
            Console.WriteLine("x^2 - {0,3} * y^2 = 1 for x = {1,27:n0} and y = {2,25:n0}", n, x, y)
        Next
    End Sub
End Module
