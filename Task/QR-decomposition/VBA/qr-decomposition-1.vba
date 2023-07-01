Option Base 1
Private Function vtranspose(v As Variant) As Variant
'-- transpose a vector of length m into an mx1 matrix,
'--                       eg {1,2,3} -> {1;2;3}
    vtranspose = WorksheetFunction.Transpose(v)
End Function

Private Function mat_col(a As Variant, col As Integer) As Variant
    Dim res() As Double
    ReDim res(UBound(a))
    For i = col To UBound(a)
        res(i) = a(i, col)
    Next i
    mat_col = res
End Function

Private Function mat_norm(a As Variant) As Double
    mat_norm = Sqr(WorksheetFunction.SumProduct(a, a))
End Function

Private Function mat_ident(n As Integer) As Variant
    mat_ident = WorksheetFunction.Munit(n)
End Function

Private Function sq_div(a As Variant, p As Double) As Variant
    Dim res() As Variant
    ReDim res(UBound(a))
    For i = 1 To UBound(a)
        res(i) = a(i) / p
    Next i
    sq_div = res
End Function

Private Function sq_mul(p As Double, a As Variant) As Variant
    Dim res() As Variant
    ReDim res(UBound(a), UBound(a, 2))
    For i = 1 To UBound(a)
        For j = 1 To UBound(a, 2)
            res(i, j) = p * a(i, j)
        Next j
    Next i
    sq_mul = res
End Function

Private Function sq_sub(x As Variant, y As Variant) As Variant
    Dim res() As Variant
    ReDim res(UBound(x), UBound(x, 2))
    For i = 1 To UBound(x)
        For j = 1 To UBound(x, 2)
            res(i, j) = x(i, j) - y(i, j)
        Next j
    Next i
    sq_sub = res
End Function

Private Function matrix_mul(x As Variant, y As Variant) As Variant
    matrix_mul = WorksheetFunction.MMult(x, y)
End Function

Private Function QRHouseholder(ByVal a As Variant) As Variant
    Dim columns As Integer: columns = UBound(a, 2)
    Dim rows As Integer: rows = UBound(a)
    Dim m As Integer: m = WorksheetFunction.Max(columns, rows)
    Dim n As Integer: n = WorksheetFunction.Min(rows, columns)
    I_ = mat_ident(m)
    Q_ = I_
    Dim q As Variant
    Dim u As Variant, v As Variant, j As Integer
    For j = 1 To WorksheetFunction.Min(m - 1, n)
        u = mat_col(a, j)
        u(j) = u(j) - mat_norm(u)
        v = sq_div(u, mat_norm(u))
        q = sq_sub(I_, sq_mul(2, matrix_mul(vtranspose(v), v)))
        a = matrix_mul(q, a)
        Q_ = matrix_mul(Q_, q)
    Next j

    '-- Get the upper triangular matrix R.
    Dim R() As Variant
    ReDim R(m, n)
    For i = 1 To m 'in Phix this is n
        For j = 1 To n 'in Phix this is i to n. starting at 1 to fill zeroes
            R(i, j) = a(i, j)
        Next j
    Next i
    Dim res(2) As Variant
    res(1) = Q_
    res(2) = R
    QRHouseholder = res
End Function

Private Sub pp(m As Variant)
    For i = 1 To UBound(m)
        For j = 1 To UBound(m, 2)
            Debug.Print Format(m(i, j), "0.#####"),
        Next j
        Debug.Print
    Next i
End Sub
Public Sub main()
    a = [{12, -51,   4; 6, 167, -68; -4,  24, -41;-1,1,0;2,0,3}]
    result = QRHouseholder(a)
    q = result(1)
    r_ = result(2)
    Debug.Print "A"
    pp a
    Debug.Print "Q"
    pp q
    Debug.Print "R"
    pp r_
    Debug.Print "Q * R"
    pp matrix_mul(q, r_)
End Sub
