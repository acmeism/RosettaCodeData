Sub Main()
    Const nmax = 12, xx = 3
    Const x = xx + 1
    Dim i As Integer, j As Integer, s As String
    s = String(xx, " ") & " |"
    For j = 1 To nmax
        s = s & Right(String(x, " ") & j, x)
    Next j
    Debug.Print s
    s = String(xx, "-") & " +"
    For j = 1 To nmax
        s = s & " " & String(xx, "-")
    Next j
    Debug.Print s
    For i = 1 To nmax
        s = Right(String(xx, " ") & i, xx) & " |"
        For j = 1 To nmax
            If j >= i _
            Then s = s & Right(String(x, " ") & i * j, x) _
            Else s = s & String(x, " ")
        Next j
        Debug.Print s
    Next i
End Sub 'Main
