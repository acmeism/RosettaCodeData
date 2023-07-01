Sub Population_count()
    nmax = 30
    b = 3
    n = 0: List = "": bb = 1
    For i = 0 To nmax - 1
        List = List & " " & popcount(bb)
        bb = bb * b
    Next 'i
    Debug.Print "popcounts of the powers of " & b
    Debug.Print List
    For j = 0 To 1
        If j = 0 Then c = "evil numbers" Else c = "odious numbers"
        n = 0: List = "": i = 0
        While n < nmax
            If (popcount(i) Mod 2) = j Then
                n = n + 1
                List = List & " " & i
            End If
            i = i + 1
        Wend
        Debug.Print c
        Debug.Print List
    Next 'j
End Sub 'Population_count

Private Function popcount(x)
    Dim y, xx, xq, xr
    xx = x
    While xx > 0
        xq = Int(xx / 2)
        xr = xx - xq * 2
        If xr = 1 Then y = y + 1
        xx = xq
    Wend
    popcount = y
End Function 'popcount
