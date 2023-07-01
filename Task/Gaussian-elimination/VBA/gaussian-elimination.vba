'Option Base 1
Private Function gauss_eliminate(a As Variant, b As Variant) As Variant
    Dim n As Integer: n = UBound(b)
    Dim tmp As Variant, m As Integer, mx As Variant
    For col = 1 To n
        m = col
        mx = a(m, m)
        For i = col + 1 To n
            tmp = Abs(a(i, col))
            If tmp > mx Then
                m = i
                mx = tmp
            End If
        Next i
        If col <> m Then
            For j = 1 To UBound(a, 2)
                tmp = a(col, j)
                a(col, j) = a(m, j)
                a(m, j) = tmp
            Next j
            tmp = b(col)
            b(col) = b(m)
            b(m) = tmp
        End If
        For i = col + 1 To n
            tmp = a(i, col) / a(col, col)
            For j = col + 1 To n
                a(i, j) = a(i, j) - tmp * a(col, j)
            Next j
            a(i, col) = 0
            b(i) = b(i) - tmp * b(col)
        Next i
    Next col
    Dim x() As Variant
    ReDim x(n)
    For col = n To 1 Step -1
        tmp = b(col)
        For j = n To col + 1 Step -1
            tmp = tmp - x(j) * a(col, j)
        Next j
        x(col) = tmp / a(col, col)
    Next col
    gauss_eliminate = x
End Function
Public Sub main()
    a = [{1.00, 0.00, 0.00,  0.00,  0.00,   0.00; 1.00, 0.63, 0.39,  0.25,  0.16,   0.10; 1.00, 1.26, 1.58,  1.98,  2.49,   3.13; 1.00, 1.88, 3.55,  6.70, 12.62,  23.80; 1.00, 2.51, 6.32, 15.88, 39.90, 100.28; 1.00, 3.14, 9.87, 31.01, 97.41, 306.02}]
    b = [{-0.01, 0.61, 0.91,  0.99,  0.60,   0.02}]
    Dim s() As String, x() As Variant
    ReDim s(UBound(b)), x(UBound(b))
    Debug.Print "(";
    x = gauss_eliminate(a, b)
    For i = 1 To UBound(x)
        s(i) = CStr(x(i))
    Next i
    t = Join(s, ", ")
    Debug.Print t; ")"
End Sub
