Option Base 1
Private Function insertion_sort(s As Variant) As Variant
    Dim temp As Variant
    Dim j As Integer
    For i = 2 To UBound(s)
        temp = s(i)
        j = i - 1
        Do While s(j) > temp
            s(j + 1) = s(j)
            j = j - 1
            If j = 0 Then Exit Do
        Loop
        s(j + 1) = temp
    Next i
    insertion_sort = s
End Function

Public Sub main()
    s = [{4, 15, "delta", 2, -31, 0, "alpha", 19, "gamma", 2, 13, "beta", 782, 1}]
    Debug.Print "Before: ", Join(s, ", ")
    Debug.Print "After: ", Join(insertion_sort(s), "' ")
End Sub
