Private Function roman(n As Integer) As String
    roman = WorksheetFunction.roman(n)
End Function
Public Sub main()
    s = [{10, 2016, 800, 2769, 1666, 476, 1453}]
    For Each x In s
        Debug.Print roman(CInt(x)); " ";
    Next x
End Sub
