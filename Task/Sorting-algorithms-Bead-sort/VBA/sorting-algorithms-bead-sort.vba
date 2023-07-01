Option Base 1

Private Function sq_add(arr As Variant, x As Double) As Variant
    Dim res() As Variant
    ReDim res(UBound(arr))
    For i = 1 To UBound(arr)
        res(i) = arr(i) + x
    Next i
    sq_add = res
End Function

Private Function beadsort(ByVal a As Variant) As Variant
    Dim poles() As Variant
    ReDim poles(WorksheetFunction.Max(a))
    For i = 1 To UBound(a)
        For j = 1 To a(i)
            poles(j) = poles(j) + 1
        Next j
    Next i
    For j = 1 To UBound(a)
        a(j) = 0
    Next j
    For i = 1 To UBound(poles)
        For j = 1 To poles(i)
            a(j) = a(j) + 1
        Next j
    Next i
    beadsort = a
End Function

Public Sub main()
    Debug.Print Join(beadsort([{5, 3, 1, 7, 4, 1, 1, 20}]), ", ")
End Sub
