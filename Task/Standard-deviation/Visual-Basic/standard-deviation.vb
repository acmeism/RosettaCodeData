Function avg(what() As Variant) As Variant
    'treats non-numeric strings as zero
    Dim L0 As Variant, total As Variant
    For L0 = LBound(what) To UBound(what)
        If IsNumeric(what(L0)) Then total = total + what(L0)
    Next
    avg = total / (1 + UBound(what) - LBound(what))
End Function

Function standardDeviation(fp As Variant) As Variant
    Static list() As Variant
    Dim av As Variant, tmp As Variant, L0 As Variant

    'add to sequence if numeric
    If IsNumeric(fp) Then
        On Error GoTo makeArr   'catch undimensioned list
        ReDim Preserve list(UBound(list) + 1)
        On Error GoTo 0
        list(UBound(list)) = fp
    End If

    'get average
    av = avg(list())

    'the actual work
    For L0 = 0 To UBound(list)
        tmp = tmp + ((list(L0) - av) ^ 2)
    Next
    tmp = Sqr(tmp / (UBound(list) + 1))

    standardDeviation = tmp

    Exit Function
makeArr:
    If 9 = Err.Number Then
        ReDim list(0)
    Else
        'something's wrong
        Err.Raise Err.Number
    End If
    Resume Next
End Function

Sub tester()
    Dim x As Variant
    x = Array(2, 4, 4, 4, 5, 5, 7, 9)
    For L0 = 0 To UBound(x)
        Debug.Print standardDeviation(x(L0))
    Next
End Sub
