Module Module1

    'Determines the killing order numbering prisoners 1 to n
    Sub Josephus(n As Integer, k As Integer, m As Integer)
        Dim p = Enumerable.Range(1, n).ToList()
        Dim i = 0

        Console.Write("Prisoner killing order:")
        While p.Count > 1
            i = (i + k - 1) Mod p.Count
            Console.Write(" {0}", p(i))
            p.RemoveAt(i)
        End While
        Console.WriteLine()

        Console.WriteLine("Survivor: {0}", p(0))
    End Sub

    Sub Main()
        Josephus(5, 2, 1)
        Console.WriteLine()
        Josephus(41, 3, 1)
    End Sub

End Module
