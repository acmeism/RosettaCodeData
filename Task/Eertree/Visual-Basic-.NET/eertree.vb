Module Module1

    Class Node
        Public Sub New(Len As Integer)
            Length = Len
            Edges = New Dictionary(Of Char, Integer)
        End Sub

        Public Sub New(len As Integer, edg As Dictionary(Of Char, Integer), suf As Integer)
            Length = len
            Edges = If(IsNothing(edg), New Dictionary(Of Char, Integer), edg)
            Suffix = suf
        End Sub

        Property Edges As Dictionary(Of Char, Integer)
        Property Length As Integer
        Property Suffix As Integer
    End Class

    ReadOnly EVEN_ROOT As Integer = 0
    ReadOnly ODD_ROOT As Integer = 1

    Function Eertree(s As String) As List(Of Node)
        Dim tree As New List(Of Node) From {
            New Node(0, New Dictionary(Of Char, Integer), ODD_ROOT),
            New Node(-1, New Dictionary(Of Char, Integer), ODD_ROOT)
        }
        Dim suffix = ODD_ROOT
        Dim n As Integer
        Dim k As Integer

        For i = 1 To s.Length
            Dim c = s(i - 1)
            n = suffix
            While True
                k = tree(n).Length
                Dim b = i - k - 2
                If b >= 0 AndAlso s(b) = c Then
                    Exit While
                End If
                n = tree(n).Suffix
            End While
            If tree(n).Edges.ContainsKey(c) Then
                suffix = tree(n).Edges(c)
                Continue For
            End If
            suffix = tree.Count
            tree.Add(New Node(k + 2))
            tree(n).Edges(c) = suffix
            If tree(suffix).Length = 1 Then
                tree(suffix).Suffix = 0
                Continue For
            End If
            While True
                n = tree(n).Suffix
                Dim b = i - tree(n).Length - 2
                If b >= 0 AndAlso s(b) = c Then
                    Exit While
                End If
            End While
            Dim a = tree(n)
            Dim d = a.Edges(c)
            Dim e = tree(suffix)
            e.Suffix = d
        Next

        Return tree
    End Function

    Function SubPalindromes(tree As List(Of Node)) As List(Of String)
        Dim s As New List(Of String)
        Dim children As Action(Of Integer, String) = Sub(n As Integer, p As String)
                                                         For Each c In tree(n).Edges.Keys
                                                             Dim m = tree(n).Edges(c)
                                                             Dim p1 = c + p + c
                                                             s.Add(p1)
                                                             children(m, p1)
                                                         Next
                                                     End Sub
        children(0, "")
        For Each c In tree(1).Edges.Keys
            Dim m = tree(1).Edges(c)
            Dim ct = c.ToString()
            s.Add(ct)
            children(m, ct)
        Next
        Return s
    End Function

    Sub Main()
        Dim tree = Eertree("eertree")
        Dim result = SubPalindromes(tree)
        Dim listStr = String.Join(", ", result)
        Console.WriteLine("[{0}]", listStr)
    End Sub

End Module
