Partial Module Program
    ' Stop and Step are language keywords and must be escaped with brackets.
    Iterator Function Range(start As Integer, [stop] As Integer, Optional [step] As Integer = 1) As IEnumerable(Of Integer)
        For i = start To [stop] Step [step]
            Yield i
        Next
    End Function
End Module
