Type Graph
    n As Integer
    adj(Any, Any) As Boolean
End Type

' Create a new graph on n vertices (0..n-1), no edges.
Sub Graph_init(Byref g As Graph, Byval n As Integer)
    g.n = n
    Redim g.adj(n-1, n-1)
    For i As Integer = 0 To n-1
        For j As Integer = 0 To n-1
            g.adj(i, j) = False
        Next
    Next
End Sub

' Return a deep copy of the graph.
Sub Graph_clone(Byref src As Graph, Byref dest As Graph)
    Graph_init(dest, src.n)
    For i As Integer = 0 To src.n-1
        For j As Integer = 0 To src.n-1
            dest.adj(i, j) = src.adj(i, j)
        Next
    Next
End Sub

' Add an undirected edge u--v.
Sub Graph_add_edge(Byref g As Graph, Byval u As Integer, Byval v As Integer)
    If u < 0 Or u >= g.n Or v < 0 Or v >= g.n Then
        Print "IndexError: vertex index out of bounds"
        Sleep: End
    End If
    g.adj(u, v) = True
    g.adj(v, u) = True
End Sub

' Degree of vertex u.
Function Graph_degree(Byref g As Graph, Byval u As Integer) As Integer
    Dim d As Integer = 0
    For v As Integer = 0 To g.n-1
        If g.adj(u, v) Then d += 1
    Next
    Return d
End Function

' Compute the Chvátal closure in-place.
' Repeatedly adds edges {u,v} whenever (u,v) is a non-edge
' with degree(u) + degree(v) >= n, until no more can be added.
Sub Graph_closure(Byref g As Graph)
    Dim n As Integer = g.n
    Dim added As Boolean = True
    While added
        added = False
        For u As Integer = 0 To n-1
            For v As Integer = u+1 To n-1
                If g.adj(u, v) = 0 Then
                    If Graph_degree(g, u) + Graph_degree(g, v) >= n Then
                        Graph_add_edge(g, u, v)
                        added = True
                        Exit For, For
                    End If
                End If
            Next
            If added Then Exit For
        Next
    Wend
End Sub

' Is the graph complete?
Function Graph_isComplete(Byref g As Graph) As Boolean
    For u As Integer = 0 To g.n-1
        For v As Integer = u+1 To g.n-1
            If g.adj(u, v) = 0 Then Return False
        Next
    Next
    Return True
End Function

' Find a Hamiltonian cycle in the original graph by simple backtracking.
' Returns a list of vertices including the return to the start, or None.
Sub DFS_Hamiltonian(Byref g As Graph, visited() As Boolean, path() As Integer, Byval depth As Integer, Byref found As Boolean, Byref result As String)
    Dim n As Integer = g.n
    If found Then Exit Sub
    Dim u As Integer = path(depth)
    If depth = n-1 Then
        If g.adj(u, path(0)) Then
            For i As Integer = 0 To n-1
                result &= Str(path(i)) & " " & Chr(26) & " "
            Next
            result &= Str(path(0))
            found = True
        End If
        Exit Sub
    End If
    For v As Integer = 0 To n-1
        If Not visited(v) And g.adj(u, v) Then
            visited(v) = True
            path(depth+1) = v
            DFS_Hamiltonian(g, visited(), path(), depth+1, found, result)
            visited(v) = False
            If found Then Exit For
        End If
    Next
End Sub

Function Graph_Hamiltonian_cycle(Byref g As Graph) As String
    Dim n As Integer = g.n
    Dim visited(n-1) As Boolean
    Dim path(n-1) As Integer
    Dim found As Boolean = False
    Dim result As String = ""
    For i As Integer = 0 To n-1
        visited(i) = False
    Next
    path(0) = 0
    visited(0) = True
    DFS_Hamiltonian(g, visited(), path(), 0, found, result)
    Return Iif(found, result, "")
End Function

' Example: 5 vertices, almost complete graph missing edge 0--1.
' This satisfies Ore's condition: deg(0)=3, deg(1)=3, 3+3>=5.
Dim g As Graph
Graph_init(g, 5)

' Add all edges except (0,1)
For u As Integer = 0 To 4
    For v As Integer = u+1 To 4
        If Not (u = 0 And v = 1) Then Graph_add_edge(g, u, v)
    Next
Next

Print "Original graph degrees:"
For u As Integer = 0 To g.n-1
    Print "  deg(" & u & ") = " & Graph_degree(g, u)
Next

' Compute closure
Dim closure As Graph
Graph_clone(g, closure)
Graph_closure(closure)

Print !"\nAfter Chv tal closure:"
For u As Integer = 0 To closure.n-1
    Print " "; u; ":";
    For v As Integer = 0 To closure.n-1
        If closure.adj(u, v) Then Print v;
    Next
    Print
Next

If Graph_isComplete(closure) Then
    Print !"\nClosure is complete => graph is Hamiltonian (by Bondy-Chv tal)."
    Dim cycle As String = Graph_Hamiltonian_cycle(g)
    If cycle <> "" Then
        Print "Found Hamiltonian cycle in original graph:"
        Print cycle
    Else
        Print "Unexpected: could not find a Hamiltonian cycle."
    End If
Else
    Print !"\nClosure is not complete => no guarantee of Hamiltonian cycle."
End If

Sleep
