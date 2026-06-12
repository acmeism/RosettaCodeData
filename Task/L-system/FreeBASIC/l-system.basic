Sub Lindenmayer(s As String, rules() As String, count As Integer)
    Dim As Integer i, j, k, found
    Dim As String nxt, c, rep
    For i = 0 To count
        Print s
        nxt = ""
        For j = 1 To Len(s)
            c = Mid(s, j, 1)
            found = 0
            For k = Lbound(rules) To Ubound(rules) Step 2
                If c = rules(k) Then
                    rep = rules(k + 1)
                    found = 1
                    Exit For
                End If
            Next k
            nxt &= Iif(found = 1, rep, c)
        Next j
        s = nxt
    Next i
End Sub

Dim As String rules(3) = {"I", "M", "M", "MI"}
Lindenmayer("I", rules(), 5)

Sleep
