Private Sub Iterate(ByVal list As LinkedList(Of Integer))
    Dim node = list.First
    Do Until node Is Nothing
        node = node.Next
    Loop
    End Sub
