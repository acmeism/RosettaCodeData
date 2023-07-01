Module Module1

    Function Count(stones As String, jewels As String) As Integer
        Dim bag = jewels.ToHashSet
        Return stones.Count(AddressOf bag.Contains)
    End Function

    Sub Main()
        Console.WriteLine(Count("aAAbbbb", "Aa"))
        Console.WriteLine(Count("ZZ", "z"))
    End Sub

End Module
