Private Function medianq(s As Variant) As Double
    Dim res As Double, tmp As Integer
    Dim l As Integer, k As Integer
    res = 0
    l = UBound(s): k = WorksheetFunction.Floor_Precise((l + 1) / 2, 1)
        If l Then
            res = quick_select(s, k)
            If l Mod 2 = 0 Then
                tmp = quick_select(s, k + 1)
                res = (res + tmp) / 2
            End If
        End If
    medianq = res
End Function
Public Sub main2()
    s = [{4, 2, 3, 5, 1, 6}]
    Debug.Print medianq(s)
End Sub
