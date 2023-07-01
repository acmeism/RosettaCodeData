Option Base 1
Private Function pivotize(m As Variant) As Variant
    Dim n As Integer: n = UBound(m)
    Dim im() As Double
    ReDim im(n, n)
    For i = 1 To n
        For j = 1 To n
            im(i, j) = 0
        Next j
        im(i, i) = 1
    Next i
    For i = 1 To n
        mx = Abs(m(i, i))
        row_ = i
        For j = i To n
            If Abs(m(j, i)) > mx Then
                mx = Abs(m(j, i))
                row_ = j
            End If
        Next j
        If i <> Row Then
            For j = 1 To n
                tmp = im(i, j)
                im(i, j) = im(row_, j)
                im(row_, j) = tmp
            Next j
        End If
    Next i
    pivotize = im
End Function

Private Function lu(a As Variant) As Variant
    Dim n As Integer: n = UBound(a)
    Dim l() As Double
    ReDim l(n, n)
    For i = 1 To n
        For j = 1 To n
            l(i, j) = 0
        Next j
    Next i
    u = l
    p = pivotize(a)
    a2 = WorksheetFunction.MMult(p, a)
    For j = 1 To n
        l(j, j) = 1#
        For i = 1 To j
            sum1 = 0#
            For k = 1 To i
                sum1 = sum1 + u(k, j) * l(i, k)
            Next k
            u(i, j) = a2(i, j) - sum1
        Next i
        For i = j + 1 To n
            sum2 = 0#
            For k = 1 To j
                sum2 = sum2 + u(k, j) * l(i, k)
            Next k
            l(i, j) = (a2(i, j) - sum2) / u(j, j)
        Next i
    Next j
    Dim res(4) As Variant
    res(1) = a
    res(2) = l
    res(3) = u
    res(4) = p
    lu = res
End Function

Public Sub main()

    a = [{1, 3, 5; 2, 4, 7; 1, 1, 0}]
    Debug.Print "== a,l,u,p: =="
    result = lu(a)
    For i = 1 To 4
        For j = 1 To UBound(result(1))
            For k = 1 To UBound(result(1), 2)
                Debug.Print result(i)(j, k),
            Next k
            Debug.Print
        Next j
        Debug.Print
    Next i
    a = [{11, 9,24, 2; 1, 5, 2, 6; 3,17,18, 1; 2, 5, 7, 1}]
    Debug.Print "== a,l,u,p: =="
    result = lu(a)
    For i = 1 To 4
        For j = 1 To UBound(result(1))
            For k = 1 To UBound(result(1), 2)
                Debug.Print Format(result(i)(j, k), "0.#####"),
            Next k
            Debug.Print
        Next j
        Debug.Print
    Next i
End Sub
