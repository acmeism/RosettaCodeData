Sub sierpinski(n As Integer)
    Dim lim As Integer: lim = 2 ^ n - 1
    For y = lim To 0 Step -1
        Debug.Print String$(y, " ")
        For x = 0 To lim - y
            Debug.Print IIf(x And y, "  ", "# ");
        Next
        Debug.Print
    Next y
End Sub
Public Sub main()
    Dim i As Integer
    For i = 1 To 5
        sierpinski i
    Next i
End Sub
