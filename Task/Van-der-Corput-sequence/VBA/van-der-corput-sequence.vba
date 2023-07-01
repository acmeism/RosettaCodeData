Private Function vdc(ByVal n As Integer, BASE As Variant) As Variant
    Dim res As String
    Dim digit As Integer, g As Integer, denom As Integer
    denom = 1
    Do While n
        denom = denom * BASE
        digit = n Mod BASE
        n = n \ BASE
        res = res & CStr(digit) '+ "0"
    Loop
    vdc = IIf(Len(res) = 0, "0", "0." & res)
End Function

Public Sub show_vdc()
    Dim v As Variant, j As Integer
    For i = 2 To 5
        Debug.Print "Base "; i; ": ";
        For j = 0 To 9
            v = vdc(j, i)
            Debug.Print v; " ";
        Next j
        Debug.Print
    Next i
End Sub
