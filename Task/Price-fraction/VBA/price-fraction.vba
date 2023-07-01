Option Explicit

Sub Main()
Dim test, i As Long
    test = Array(0.34, 0.070145, 0.06, 0.05, 0.50214, 0.56, 1#, 0.99, 0#, 0.7388727)
    For i = 0 To UBound(test)
        Debug.Print test(i) & " := " & Price_Fraction(CSng(test(i)))
    Next i
End Sub

Private Function Price_Fraction(n As Single) As Single
Dim Vin, Vout, i As Long
    Vin = Array(0.06, 0.11, 0.16, 0.21, 0.26, 0.31, 0.36, 0.41, 0.46, 0.51, 0.56, 0.61, 0.66, 0.71, 0.76, 0.81, 0.86, 0.91, 0.96, 1.01)
    Vout = Array(0.1, 0.18, 0.26, 0.32, 0.38, 0.44, 0.5, 0.54, 0.58, 0.62, 0.66, 0.7, 0.74, 0.78, 0.82, 0.86, 0.9, 0.94, 0.98, 1#)
    For i = 0 To UBound(Vin)
        If n < Vin(i) Then Price_Fraction = Vout(i): Exit For
    Next i
End Function
