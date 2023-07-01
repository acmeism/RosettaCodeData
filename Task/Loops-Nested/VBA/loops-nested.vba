Public Sub LoopsNested()
    Dim a(1 To 10, 1 To 10) As Integer
    Randomize
    For i = 1 To 10
        For j = 1 To 10
            a(i, j) = Int(20 * Rnd) + 1
        Next j
    Next i
    For i = 1 To 10
        For j = 1 To 10
            If a(i, j) <> 20 Then
                Debug.Print a(i, j),
            Else
                i = 10 'Upperbound iterator outerloop
                Exit For 'Exit For exits only innerloop
            End If
        Next j
        Debug.Print
    Next i
End Sub
