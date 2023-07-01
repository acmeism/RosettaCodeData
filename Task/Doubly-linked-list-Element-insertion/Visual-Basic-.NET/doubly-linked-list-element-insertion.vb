Public Sub Insert(ByVal a As Node(Of T), ByVal b As Node(Of T), ByVal c As T)
    Dim node As New Node(Of T)(value)
    a.Next = node
    node.Previous = a
    b.Previous = node
    node.Next = b
End Sub
