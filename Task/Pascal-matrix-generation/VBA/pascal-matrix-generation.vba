Option Base 1
Private Function pascal_upper(n As Integer)
    Dim res As Variant: ReDim res(n, n)
    For j = 1 To n
        res(1, j) = 1
    Next j
    For i = 2 To n
        res(i, 1) = 0
        For j = 2 To i
            res(j, i) = res(j, i - 1) + res(j - 1, i - 1)
        Next j
        For j = i + 1 To n
            res(j, i) = 0
        Next j
    Next i
    pascal_upper = res
End Function

Private Function pascal_symmetric(n As Integer)
    Dim res As Variant: ReDim res(n, n)
    For i = 1 To n
        res(i, 1) = 1
        res(1, i) = 1
    Next i
    For i = 2 To n
        For j = 2 To n
            res(i, j) = res(i - 1, j) + res(i, j - 1)
        Next j
    Next i
    pascal_symmetric = res
End Function

Private Sub pp(m As Variant)
    For i = 1 To UBound(m)
        For j = 1 To UBound(m, 2)
            Debug.Print Format(m(i, j), "@@@");
        Next j
        Debug.Print
    Next i
End Sub

Public Sub main()
    Debug.Print "=== Pascal upper matrix ==="
    pp pascal_upper(5)
    Debug.Print "=== Pascal lower matrix ==="
    pp WorksheetFunction.Transpose(pascal_upper(5))
    Debug.Print "=== Pascal symmetrical matrix ==="
    pp pascal_symmetric(5)
End Sub
