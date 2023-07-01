Option Explicit
Dim o As String
Sub floyd(L As Integer)
    Dim r, c, m, n As Integer
    n = L * (L - 1) / 2
    m = 1
    For r = 1 To L
        o = o & vbCrLf
        For c = 1 To r
            o = o & Space(Len(CStr(n + c)) - Len(CStr(m))) & m & " "
            m = m + 1
        Next
    Next
End Sub
Sub triangle()
    o = "5 lines"
    Call floyd(5)
    o = o & vbCrLf & "14 lines"
    Call floyd(14)
    With Selection
        .Font.Name = "Courier New"
        .TypeText Text:=o
    End With
End Sub
