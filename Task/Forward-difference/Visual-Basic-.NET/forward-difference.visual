Module ForwardDifference

    Sub Main()
        Dim lNum As New List(Of Integer)(New Integer() {90, 47, 58, 29, 22, 32, 55, 5, 55, 73})
        For i As UInteger = 0 To 9
            Console.WriteLine(String.Join(" ", (From n In Difference(i, lNum) Select String.Format("{0,5}", n)).ToArray()))
        Next
        Console.ReadKey()
    End Sub

    Private Function Difference(ByVal Level As UInteger, ByVal Numbers As List(Of Integer)) As List(Of Integer)
        If Level >= Numbers.Count Then Throw New ArgumentOutOfRangeException("Level", "Level must be less than number of items in Numbers")

        For i As Integer = 1 To Level
            Numbers = (From n In Enumerable.Range(0, Numbers.Count - 1) _
                       Select Numbers(n + 1) - Numbers(n)).ToList()
        Next

        Return Numbers
    End Function

End Module
