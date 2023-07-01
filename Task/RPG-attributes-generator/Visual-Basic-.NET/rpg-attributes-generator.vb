Module Module1

    Dim r As New Random

    Function getThree(n As Integer) As List(Of Integer)
        getThree = New List(Of Integer)
        For i As Integer = 1 To 4 : getThree.Add(r.Next(n) + 1) : Next
        getThree.Sort() : getThree.RemoveAt(0)
    End Function

    Function getSix() As List(Of Integer)
        getSix = New List(Of Integer)
        For i As Integer = 1 To 6 : getSix.Add(getThree(6).Sum) : Next
    End Function

    Sub Main(args As String())
        Dim good As Boolean = False : Do
            Dim gs As List(Of Integer) = getSix(), gss As Integer = gs.Sum,
                hvc As Integer = gs.FindAll(Function(x) x > 14).Count
            Console.Write("attribs: {0}, sum={1}, ({2} sum, high vals={3})",
                          String.Join(", ", gs), gss, If(gss >= 75, "good", "low"), hvc)
            good = gs.Sum >= 75 AndAlso hvc > 1
            Console.WriteLine(" - {0}", If(good, "success", "failure"))
        Loop Until good
    End Sub
End Module
