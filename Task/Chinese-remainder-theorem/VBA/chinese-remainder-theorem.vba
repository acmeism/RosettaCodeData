Private Function chinese_remainder(n As Variant, a As Variant) As Variant
    Dim p As Long, prod As Long, tot As Long
    prod = 1: tot = 0
    For i = 1 To UBound(n)
        prod = prod * n(i)
    Next i
    Dim m As Variant
    For i = 1 To UBound(n)
        p = prod / n(i)
        m = mul_inv(p, n(i))
        If WorksheetFunction.IsText(m) Then
            chinese_remainder = "fail"
            Exit Function
        End If
        tot = tot + a(i) * m * p
    Next i
    chinese_remainder = tot Mod prod
End Function
Public Sub re()
    Debug.Print chinese_remainder([{3,5,7}], [{2,3,2}])
    Debug.Print chinese_remainder([{11,12,13}], [{10,4,12}])
    Debug.Print chinese_remainder([{11,22,19}], [{10,4,9}])
    Debug.Print chinese_remainder([{100,23}], [{19,0}])
End Sub
