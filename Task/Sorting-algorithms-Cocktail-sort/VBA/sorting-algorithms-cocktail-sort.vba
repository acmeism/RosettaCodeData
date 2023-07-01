Function cocktail_sort(ByVal s As Variant) As Variant
    Dim swapped As Boolean
    Dim f As Integer, t As Integer, d As Integer, tmp As Integer
    swapped = True
    f = 1
    t = UBound(s) - 1
    d = 1
    Do While swapped
        swapped = 0
        For i = f To t Step d
            If Val(s(i)) > Val(s(i + 1)) Then
                tmp = s(i)
                s(i) = s(i + 1)
                s(i + 1) = tmp
                swapped = True
            End If
        Next i
        '-- swap to and from, and flip direction.
        '-- additionally, we can reduce one element to be
        '-- examined, depending on which way we just went.
        tmp = f
        f = t + (d = 1)
        t = tmp + (d = -1)
        d = -d
    Loop
    cocktail_sort = s
End Function

Public Sub main()
    Dim s(9) As Variant
    For i = 0 To 9
        s(i) = CStr(Int(1000 * Rnd))
    Next i
    Debug.Print Join(s, ", ")
    Debug.Print Join(cocktail_sort(s), ", ")
End Sub
