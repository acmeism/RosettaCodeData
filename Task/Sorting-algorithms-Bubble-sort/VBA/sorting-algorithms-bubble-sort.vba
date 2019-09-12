Private Function bubble_sort(s As Variant) As Variant
    Dim tmp As Variant
    Dim changed As Boolean
    For j = UBound(s) To 1 Step -1
        changed = False
        For i = 1 To j - 1
            If s(i) > s(i + 1) Then
                tmp = s(i)
                s(i) = s(i + 1)
                s(i + 1) = tmp
                changed = True
            End If
        Next i
        If Not changed Then
            Exit For
        End If
    Next j
    bubble_sort = s
End Function

Public Sub main()
    s = [{4, 15, "delta", 2, -31, 0, "alfa", 19, "gamma", 2, 13, "beta", 782, 1}]
    Debug.Print "Before: "
    Debug.Print Join(s, ", ")
    Debug.Print "After: "
    Debug.Print Join(bubble_sort(s), ", ")
End Sub
