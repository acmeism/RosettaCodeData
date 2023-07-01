Module Program
    Sub Main()
        Dim list As New List(Of Integer)({0, 1, 2, 3, 4, 5, 6, 7, 8, 9})
        Dim rng As New Random()
        Dim randomElement = list(rng.Next(list.Count)) ' Upper bound is exclusive.
        Console.WriteLine("I picked element {0}", randomElement)
    End Sub
End Module
