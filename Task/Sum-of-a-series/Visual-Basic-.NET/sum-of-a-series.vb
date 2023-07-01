' Sum of a series
    Sub SumOfaSeries()
        Dim s As Double
        s = 0
        For i = 1 To 1000
            s = s + 1 / i ^ 2
        Next 'i
        Console.WriteLine(s)
    End Sub
