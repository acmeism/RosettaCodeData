Sub catalan()
    Const n = 15
    Dim t(n + 2) As Long
    Dim i  As Integer, j As Integer
    t(1) = 1
    For i = 1 To n
        For j = i + 1 To 2 Step -1
            t(j) = t(j) + t(j - 1)
        Next j
        t(i + 1) = t(i)
        For j = i + 2 To 2 Step -1
            t(j) = t(j) + t(j - 1)
        Next j
        Debug.Print i, t(i + 1) - t(i)
    Next i
End Sub 'catalan
