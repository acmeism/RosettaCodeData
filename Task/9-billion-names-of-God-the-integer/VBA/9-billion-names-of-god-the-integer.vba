Public Sub nine_billion_names()
    Dim p(25, 25) As Long
    p(1, 1) = 1
    For i = 2 To 25
        For j = 1 To i
            p(i, j) = p(i - 1, j - 1) + p(i - j, j)
        Next j
    Next i
    For i = 1 To 25
        Debug.Print String$(50 - 2 * i, " ");
        For j = 1 To i
            Debug.Print String$(4 - Len(CStr(p(i, j))), " ") & p(i, j);
        Next j
        Debug.Print
    Next i
End Sub
