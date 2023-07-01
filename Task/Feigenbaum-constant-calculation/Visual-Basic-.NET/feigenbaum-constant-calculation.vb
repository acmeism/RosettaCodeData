Module Module1

    Sub Main()
        Dim maxIt = 13
        Dim maxItJ = 10
        Dim a1 = 1.0
        Dim a2 = 0.0
        Dim d1 = 3.2
        Console.WriteLine(" i       d")
        For i = 2 To maxIt
            Dim a = a1 + (a1 - a2) / d1
            For j = 1 To maxItJ
                Dim x = 0.0
                Dim y = 0.0
                For k = 1 To 1 << i
                    y = 1.0 - 2.0 * y * x
                    x = a - x * x
                Next
                a -= x / y
            Next
            Dim d = (a1 - a2) / (a - a1)
            Console.WriteLine("{0,2:d}    {1:f8}", i, d)
            d1 = d
            a2 = a1
            a1 = a
        Next
    End Sub

End Module
