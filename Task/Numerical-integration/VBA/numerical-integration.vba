Option Explicit
Option Base 1

Function Quad(ByVal f As String, ByVal a As Double, _
        ByVal b As Double, ByVal n As Long, _
        ByVal u As Variant, ByVal v As Variant) As Double
    Dim m As Long, h As Double, x As Double, s As Double, i As Long, j As Long
    m = UBound(u)
    h = (b - a) / n
    s = 0#
    For i = 1 To n
        x = a + (i - 1) * h
        For j = 1 To m
            s = s + v(j) * Application.Run(f, x + h * u(j))
        Next
    Next
    Quad = s * h
End Function

Function f1fun(x As Double) As Double
    f1fun = x ^ 3
End Function

Function f2fun(x As Double) As Double
    f2fun = 1 / x
End Function

Function f3fun(x As Double) As Double
    f3fun = x
End Function

Sub Test()
    Dim fun, f, coef, c
    Dim i As Long, j As Long, s As Double

    fun = Array(Array("f1fun", 0, 1, 100, 1 / 4), _
        Array("f2fun", 1, 100, 1000, Log(100)), _
        Array("f3fun", 0, 5000, 50000, 5000 ^ 2 / 2), _
        Array("f3fun", 0, 6000, 60000, 6000 ^ 2 / 2))

    coef = Array(Array("Left rect.  ", Array(0, 1), Array(1, 0)), _
        Array("Right rect. ", Array(0, 1), Array(0, 1)), _
        Array("Midpoint    ", Array(0.5), Array(1)), _
        Array("Trapez.     ", Array(0, 1), Array(0.5, 0.5)), _
        Array("Simpson     ", Array(0, 0.5, 1), Array(1 / 6, 4 / 6, 1 / 6)))

    For i = 1 To UBound(fun)
        f = fun(i)
        Debug.Print f(1)
        For j = 1 To UBound(coef)
            c = coef(j)
            s = Quad(f(1), f(2), f(3), f(4), c(2), c(3))
            Debug.Print "  " + c(1) + ": ", s, (s - f(5)) / f(5)
        Next j
    Next i
End Sub
