Function comb_sort(ByVal s As Variant) As Variant
    Dim gap As Integer: gap = UBound(s)
    Dim swapped As Integer
    Do While True
        gap = WorksheetFunction.Max(WorksheetFunction.Floor_Precise(gap / 1.3), 1)
        swapped = False
        For i = 0 To UBound(s) - gap
            si = Val(s(i))
            If si > Val(s(i + gap)) Then
                s(i) = s(i + gap)
                s(i + gap) = CStr(si)
                swapped = True
            End If
        Next i
        If gap = 1 And Not swapped Then Exit Do
    Loop
    comb_sort = s
End Function

Public Sub main()
    Dim s(9) As Variant
    For i = 0 To 9
        s(i) = CStr(Int(1000 * Rnd))
    Next i
    Debug.Print Join(s, ", ")
    Debug.Print Join(comb_sort(s), ", ")
End Sub
