Option Explicit
Declare Function ffun Lib "vbafun" (ByRef x As Double, ByRef y As Double) As Double
Sub Test()
    Dim x As Double, y As Double
    x = 2#
    y = 10#
    Debug.Print ffun(x, y)
End Sub
