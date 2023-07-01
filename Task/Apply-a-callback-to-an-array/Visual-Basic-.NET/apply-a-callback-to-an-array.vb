Module Program
    Function OneMoreThan(i As Integer) As Integer
        Return i + 1
    End Function

    Sub Main()
        Dim source As Integer() = {1, 2, 3}

        ' Create a delegate from an existing method.
        Dim resultEnumerable1 = source.Select(AddressOf OneMoreThan)

        ' The above is just syntax sugar for this; extension methods can be called as if they were instance methods of the first parameter.
        resultEnumerable1 = Enumerable.Select(source, AddressOf OneMoreThan)

        ' Or use an anonymous delegate.
        Dim resultEnumerable2 = source.Select(Function(i) i + 1)

        ' The sequences are the same.
        Console.WriteLine(Enumerable.SequenceEqual(resultEnumerable1, resultEnumerable2))

        Dim resultArr As Integer() = resultEnumerable1.ToArray()

        Array.ForEach(resultArr, AddressOf Console.WriteLine)
    End Sub
End Module
