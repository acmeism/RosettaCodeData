Option Base 1
Private Function median(tbl As Variant, lo As Integer, hi As Integer)
    Dim l As Integer: l = hi - lo + 1
    Dim m As Integer: m = lo + WorksheetFunction.Floor_Precise(l / 2)
    If l Mod 2 = 1 Then
        median = tbl(m)
    Else
        median = (tbl(m - 1) + tbl(m)) / 2
    End if
End Function
Private Function fivenum(tbl As Variant) As Variant
    Sort tbl, UBound(tbl)
    Dim l As Integer: l = UBound(tbl)
    Dim m As Integer: m = WorksheetFunction.Floor_Precise(l / 2) + l Mod 2
    Dim r(5) As String
    r(1) = CStr(tbl(1))
    r(2) = CStr(median(tbl, 1, m))
    r(3) = CStr(median(tbl, 1, l))
    r(4) = CStr(median(tbl, m + 1, l))
    r(5) = CStr(tbl(l))
    fivenum = r
End Function
Public Sub main()
    Dim x1 As Variant, x2 As Variant, x3 As Variant
    x1 = [{15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43}]
    x2 = [{36, 40, 7, 39, 41, 15}]
    x3 = [{0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594, 0.73438555, -0.03035726, 1.46675970, -0.74621349, -0.72588772, 0.63905160, 0.61501527, -0.98983780, -1.00447874, -0.62759469, 0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578}]
    Debug.Print Join(fivenum(x1), " | ")
    Debug.Print Join(fivenum(x2), " | ")
    Debug.Print Join(fivenum(x3), " | ")
End Sub
