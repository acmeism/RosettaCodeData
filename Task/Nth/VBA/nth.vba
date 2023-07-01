Private Function ordinals() As Variant
    ordinals = [{"th","st","nd","rd"}]
End Function

Private Function Nth(n As Variant, Optional apostrophe As Boolean = False) As String
    Dim mod10 As Integer: mod10 = n Mod 10 + 1
    If mod10 > 4 Or n Mod 100 = mod10 + 9 Then mod10 = 1
    Nth = CStr(n) & String$(Val(-apostrophe), "'") & ordinals()(mod10)
End Function

Public Sub main()
    Ranges = [{0,25;250,265;1000,1025}]
    For i = 1 To UBound(Ranges)
        For j = Ranges(i, 1) To Ranges(i, 2)
            If j Mod 10 = 0 Then Debug.Print
            Debug.Print Format(Nth(j, i = 2), "@@@@@@@");
        Next j
        Debug.Print
    Next i
End Sub
