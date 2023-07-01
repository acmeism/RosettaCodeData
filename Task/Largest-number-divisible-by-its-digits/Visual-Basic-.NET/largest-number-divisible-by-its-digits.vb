Module Module1

    Function ChkDec(num As Integer) As Boolean
        Dim sett As New HashSet(Of Integer)
        Return num.ToString() _
            .Select(Function(c) Asc(c) - Asc("0")) _
            .All(Function(d) (d <> 0) AndAlso (num Mod d = 0) AndAlso sett.Add(d))
    End Function

    Sub Main()
        Dim result = Enumerable.Range(0, 98764321) _
            .Reverse() _
            .Where(AddressOf ChkDec) _
            .First()
        Console.WriteLine(result)
    End Sub

End Module
