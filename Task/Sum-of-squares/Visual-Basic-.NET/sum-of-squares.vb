 Private Shared Function sumsq(ByVal i As ICollection(Of Integer)) As Integer
        If i Is Nothing OrElse i.Count = 0 Then
            Return 0
        End If
        Return i.[Select](Function(x) x * x).Sum()
 End Function

 Private Shared Sub Main()
        Dim a As Integer() = New Integer() {1, 2, 3, 4, 5}
        ' 55
        Console.WriteLine(sumsq(a))

        For K As Integer = 0 To 16
               Console.WriteLine("SumOfSquares({0}) = {1}", K, SumOfSquares(K))
        Next
 End Sub
 Function SumOfSquares(ByVal Max As Integer)
        Dim Square As Integer = 0
        Dim Add As Integer = 1
        Dim Sum As Integer = 0
        For J As Integer = 0 To Max - 1
            Square += Add
            Add += 2
            Sum += Square
        Next
        Return Sum
 End Function

 Function SumOfSquaresByMult(ByVal Max As Integer)
        Dim Sum As Integer = 0
        For J As Integer = 1 To Max
            Sum += J * J
        Next
        Return Sum
 End Function
