Option Base 1
Private Function polynomial_regression(y As Variant, x As Variant, degree As Integer) As Variant
    Dim a() As Double
    ReDim a(UBound(x), 2)
    For i = 1 To UBound(x)
        For j = 1 To degree
            a(i, j) = x(i) ^ j
        Next j
    Next i
    polynomial_regression = WorksheetFunction.LinEst(WorksheetFunction.Transpose(y), a, True, True)
End Function
Public Sub main()
    x = [{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}]
    y = [{1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321}]
    result = polynomial_regression(y, x, 2)
    Debug.Print "coefficients   : ";
    For i = UBound(result, 2) To 1 Step -1
        Debug.Print Format(result(1, i), "0.#####"),
    Next i
    Debug.Print
    Debug.Print "standard errors: ";
    For i = UBound(result, 2) To 1 Step -1
        Debug.Print Format(result(2, i), "0.#####"),
    Next i
    Debug.Print vbCrLf
    Debug.Print "R^2 ="; result(3, 1)
    Debug.Print "F   ="; result(4, 1)
    Debug.Print "Degrees of freedom:"; result(4, 2)
    Debug.Print "Standard error of y estimate:"; result(3, 2)
End Sub
