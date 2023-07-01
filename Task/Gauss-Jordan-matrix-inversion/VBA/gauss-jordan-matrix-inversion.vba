Private Function inverse(mat As Variant) As Variant
    Dim len_ As Integer: len_ = UBound(mat)
    Dim tmp() As Variant
    ReDim tmp(2 * len_ + 1)
    Dim aug As Variant
    ReDim aug(len_)
    For i = 0 To len_
        If UBound(mat(i)) <> len_ Then Debug.Print 9 / 0 '-- "Not a square matrix"
        aug(i) = tmp
        For j = 0 To len_
            aug(i)(j) = mat(i)(j)
        Next j
        '-- augment by identity matrix to right
        aug(i)(i + len_ + 1) = 1
    Next i
    aug = ToReducedRowEchelonForm(aug)
    Dim inv As Variant
    inv = mat
    '-- remove identity matrix to left
    For i = 0 To len_
        For j = len_ + 1 To 2 * len_ + 1
            inv(i)(j - len_ - 1) = aug(i)(j)
        Next j
    Next i
    inverse = inv
End Function

Public Sub main()
    Dim test As Variant
    test = inverse(Array( _
        Array(2, -1, 0), _
        Array(-1, 2, -1), _
        Array(0, -1, 2)))
    For i = LBound(test) To UBound(test)
        For j = LBound(test(0)) To UBound(test(0))
            Debug.Print test(i)(j),
        Next j
    Debug.Print
    Next i
End Sub
