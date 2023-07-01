Dim s As Variant
Private Function quick_select(ByRef s As Variant, k As Integer) As Integer
    Dim left As Integer, right As Integer, pos As Integer
    Dim pivotValue As Integer, tmp As Integer
    left = 1: right = UBound(s)
    Do While left < right
        pivotValue = s(k)
        tmp = s(k)
        s(k) = s(right)
        s(right) = tmp
        pos = left
        For i = left To right
            If s(i) < pivotValue Then
                tmp = s(i)
                s(i) = s(pos)
                s(pos) = tmp
                pos = pos + 1
            End If
        Next i
        tmp = s(right)
        s(right) = s(pos)
        s(pos) = tmp
        If pos = k Then
            Exit Do
        End If
        If pos < k Then
            left = pos + 1
        Else
            right = pos - 1
        End If
    Loop
    quick_select = s(k)
End Function
Public Sub main()
    Dim r As Integer, i As Integer
    s = [{9, 8, 7, 6, 5, 0, 1, 2, 3, 4}]
    For i = 1 To 10
        r = quick_select(s, i) 's is ByRef parameter
        Debug.Print IIf(i < 10, r & ", ", "" & r);
    Next i
End Sub
