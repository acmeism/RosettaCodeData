Dim As Integer t(2, 3) = {{1,2},{3,4,1},{5}}
Dim As Integer i, j, p(6)
Dim As String pStr(6) = {"Payload#0", "Payload#1", "Payload#2", "Payload#3", "Payload#4", "Payload#5", "Payload#6"}
Dim As Boolean q(6)

For i = Lbound(t) To Ubound(t)
    For j = Lbound(t, 2) To Ubound(t, 2)
        If t(i, j) <> 0 Then
            q(t(i, j)) = True
            t(i, j) += 1
        End If
    Next j
Next i

For i = Lbound(t) To Ubound(t)
    For j = Lbound(t, 2) To Ubound(t, 2)
        If t(i, j) <> 0 Then Print pStr(t(i, j)-1); " ";
    Next j
    Print
Next i

For i = Lbound(q) To Ubound(q)
    If q(i) = False Then Print pStr(i); " is not used"
Next i

Sleep
