Public Sub main()
    s = [{1,2,3,3,3,4,4,4,5,5,6}]
    t = WorksheetFunction.Mode_Mult(s)
    For Each x In t
        Debug.Print x;
    Next x
End Sub
