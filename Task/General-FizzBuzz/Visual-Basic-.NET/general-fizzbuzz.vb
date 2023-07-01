Imports System.Globalization

Module Program
    Sub Main()
        Console.Write("Max: ")
        Dim max = Integer.Parse(Console.ReadLine(), CultureInfo.InvariantCulture)

        Dim factors As New SortedDictionary(Of Integer, String)

        Const NUM_FACTORS = 3
        For i = 1 To NUM_FACTORS
            Console.Write("Factor {0}: ", i)
            Dim input = Console.ReadLine().Split()
            factors.Add(Integer.Parse(input(0), CultureInfo.InvariantCulture), input(1))
        Next

        For i = 1 To max
            Dim anyMatches = False
            For Each factor In factors
                If i Mod factor.Key = 0 Then
                    Console.Write(factor.Value)
                    anyMatches = True
                End If
            Next
            If Not anyMatches Then Console.Write(i)
            Console.WriteLine()
        Next
    End Sub
End Module
