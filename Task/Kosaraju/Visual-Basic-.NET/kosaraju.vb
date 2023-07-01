Module Module1

    Function Kosaraju(g As List(Of List(Of Integer))) As List(Of Integer)
        Dim size = g.Count
        Dim vis(size - 1) As Boolean
        Dim l(size - 1) As Integer
        Dim x = size

        Dim t As New List(Of List(Of Integer))
        For i = 1 To size
            t.Add(New List(Of Integer))
        Next

        Dim visit As Action(Of Integer) = Sub(u As Integer)
                                              If Not vis(u) Then
                                                  vis(u) = True
                                                  For Each v In g(u)
                                                      visit(v)
                                                      t(v).Add(u)
                                                  Next
                                                  x -= 1
                                                  l(x) = u
                                              End If
                                          End Sub

        For i = 1 To size
            visit(i - 1)
        Next
        Dim c(size - 1) As Integer

        Dim assign As Action(Of Integer, Integer) = Sub(u As Integer, root As Integer)
                                                        If vis(u) Then
                                                            vis(u) = False
                                                            c(u) = root
                                                            For Each v In t(u)
                                                                assign(v, root)
                                                            Next
                                                        End If
                                                    End Sub

        For Each u In l
            assign(u, u)
        Next

        Return c.ToList
    End Function

    Sub Main()
        Dim g = New List(Of List(Of Integer)) From {
            New List(Of Integer) From {1},
            New List(Of Integer) From {2},
            New List(Of Integer) From {0},
            New List(Of Integer) From {1, 2, 4},
            New List(Of Integer) From {3, 5},
            New List(Of Integer) From {2, 6},
            New List(Of Integer) From {5},
            New List(Of Integer) From {4, 6, 7}
        }

        Dim output = Kosaraju(g)
        Console.WriteLine("[{0}]", String.Join(", ", output))
    End Sub

End Module
