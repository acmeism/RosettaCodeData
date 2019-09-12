Public Sub least_squares()
    x = [{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}]
    y = [{1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321}]
    Dim a() As Double
    ReDim a(UBound(x), 3)
    For i = 1 To UBound(x)
        For j = 1 To 3
            a(i, j) = x(i) ^ (j - 1)
        Next j
    Next i
    result = QRHouseholder(a)
    q = result(1)
    r_ = result(2)
    t = WorksheetFunction.Transpose(q)
    b = matrix_mul(t, vtranspose(y))
    Dim z(3) As Double
    For k = 3 To 1 Step -1
        Dim s As Double: s = 0
        If k < 3 Then
            For j = k + 1 To 3
                s = s + r_(k, j) * z(j)
            Next j
        End If
        z(k) = (b(k, 1) - s) / r_(k, k)
    Next k
    Debug.Print "Least-squares solution:",
    For i = 1 To 3
        Debug.Print Format(z(i), "0.#####"),
    Next i
End Sub
