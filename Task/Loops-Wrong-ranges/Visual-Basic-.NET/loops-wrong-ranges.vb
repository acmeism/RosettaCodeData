Module Program
    Sub Main()
        Example(-2, 2, 1, "Normal")
        Example(-2, 2, 0, "Zero increment")
        Example(-2, 2, -1, "Increments away from stop value")
        Example(-2, 2, 10, "First increment is beyond stop value")
        Example(2, -2, 1, "Start more than stop: positive increment")
        Example(2, 2, 1, "Start equal stop: positive increment")
        Example(2, 2, -1, "Start equal stop: negative increment")
        Example(2, 2, 0, "Start equal stop: zero increment")
        Example(0, 0, 0, "Start equal stop equal zero: zero increment")
    End Sub

    ' Stop is a keyword and must be escaped using brackets.
    Iterator Function Range(start As Integer, [stop] As Integer, increment As Integer) As IEnumerable(Of Integer)
        For i = start To [stop] Step increment
            Yield i
        Next
    End Function

    Sub Example(start As Integer, [stop] As Integer, increment As Integer, comment As String)
        ' Add a space, pad to length 50 with hyphens, and add another space.
        Console.Write((comment & " ").PadRight(50, "-"c) & " ")

        Const MAX_ITER = 9

        Dim iteration = 0
        ' The For Each loop enumerates the IEnumerable.
        For Each i In Range(start, [stop], increment)
            Console.Write("{0,2} ", i)

            iteration += 1
            If iteration > MAX_ITER Then Exit For
        Next

        Console.WriteLine()
    End Sub
End Module
