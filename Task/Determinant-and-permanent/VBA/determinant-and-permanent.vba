Option Base 1
Private Function minor(a As Variant, x As Integer, y As Integer) As Variant
    Dim l As Integer: l = UBound(a) - 1
    Dim result() As Double
    If l > 0 Then ReDim result(l, l)
    For i = 1 To l
        For j = 1 To l
            result(i, j) = a(i - (i >= x), j - (j >= y))
        Next j
    Next i
    minor = result
End Function

Private Function det(a As Variant)
    If IsArray(a) Then
        If UBound(a) = 1 Then
            On Error GoTo err
            det = a(1, 1)
            Exit Function
        End If
    Else
        det = a
        Exit Function
    End If
    Dim sgn_ As Integer: sgn_ = 1
    Dim res As Integer: res = 0
    Dim i As Integer
    For i = 1 To UBound(a)
        res = res + sgn_ * a(1, i) * det(minor(a, 1, i))
        sgn_ = sgn_ * -1
    Next i
    det = res
    Exit Function
err:
    det = a(1)
End Function

Private Function perm(a As Variant) As Double
    If IsArray(a) Then
        If UBound(a) = 1 Then
            On Error GoTo err
            perm = a(1, 1)
            Exit Function
        End If
    Else
        perm = a
        Exit Function
    End If
    Dim res As Double
    Dim i As Integer
    For i = 1 To UBound(a)
        res = res + a(1, i) * perm(minor(a, 1, i))
    Next i
    perm = res
    Exit Function
err:
    perm = a(1)
End Function

Public Sub main()
    Dim tests(13) As Variant
    tests(1) = [{1,  2; 3,  4}]
    '--Determinant: -2, permanent: 10
    tests(2) = [{2, 9, 4; 7, 5, 3; 6, 1, 8}]
    '--Determinant: -360, permanent: 900
    tests(3) = [{ 1,  2,  3,  4; 4,  5,  6,  7; 7,  8,  9, 10; 10, 11, 12, 13}]
    '--Determinant: 0, permanent: 29556
    tests(4) = [{ 0,  1,  2,  3,  4; 5,  6,  7,  8,  9; 10, 11, 12, 13, 14; 15, 16, 17, 18, 19; 20, 21, 22, 23, 24}]
    '--Determinant: 0, permanent: 6778800
    tests(5) = [{5}]
    '--Determinant: 5, permanent: 5
    tests(6) = [{1,0,0; 0,1,0; 0,0,1}]
    '--Determinant: 1, permanent: 1
    tests(7) = [{0,0,1; 0,1,0; 1,0,0}]
    '--Determinant: -1, Permanent: 1
    tests(8) = [{4,3; 2,5}]
    '--Determinant: 14, Permanent: 26
    tests(9) = [{2,5; 4,3}]
    '--Determinant: -14, Permanent: 26
    tests(10) = [{4,4; 2,2}]
    '--Determinant: 0, Permanent: 16
    tests(11) = [{7,    2,      -2,     4; 4,    4,      1,      7; 11,   -8,     9,      10; 10,   5,      12,     13}]
    '--det:  -4319   permanent:      10723
    tests(12) = [{-2,   2,      -3; -1,   1,      3; 2 ,   0,      -1}]
    '--det:  18      permanent:      10
    tests(13) = 13
    Debug.Print "Determinant", "Builtin det", "Permanent"
    For i = 1 To 12
        Debug.Print det(tests(i)), WorksheetFunction.MDeterm(tests(i)), perm(tests(i))
    Next i
    Debug.Print det(tests(13)), "error", perm(tests(13))
End Sub
