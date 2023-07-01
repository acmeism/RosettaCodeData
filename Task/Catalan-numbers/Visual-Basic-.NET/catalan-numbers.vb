Module Module1

    Function Factorial(n As Double) As Double
        If n < 1 Then
            Return 1
        End If

        Dim result = 1.0
        For i = 1 To n
            result = result * i
        Next

        Return result
    End Function

    Function FirstOption(n As Double) As Double
        Return Factorial(2 * n) / (Factorial(n + 1) * Factorial(n))
    End Function

    Function SecondOption(n As Double) As Double
        If n = 0 Then
            Return 1
        End If

        Dim sum = 0
        For i = 0 To n - 1
            sum = sum + SecondOption(i) * SecondOption((n - 1) - i)
        Next
        Return sum
    End Function

    Function ThirdOption(n As Double) As Double
        If n = 0 Then
            Return 1
        End If

        Return ((2 * (2 * n - 1)) / (n + 1)) * ThirdOption(n - 1)
    End Function

    Sub Main()
        Const MaxCatalanNumber = 15

        Dim initial As DateTime
        Dim final As DateTime
        Dim ts As TimeSpan

        initial = DateTime.Now
        For i = 0 To MaxCatalanNumber
            Console.WriteLine("CatalanNumber({0}:{1})", i, FirstOption(i))
        Next
        final = DateTime.Now
        ts = final - initial
        Console.WriteLine("It took {0}.{1} to execute", ts.Seconds, ts.Milliseconds)
        Console.WriteLine()

        initial = DateTime.Now
        For i = 0 To MaxCatalanNumber
            Console.WriteLine("CatalanNumber({0}:{1})", i, SecondOption(i))
        Next
        final = DateTime.Now
        ts = final - initial
        Console.WriteLine("It took {0}.{1} to execute", ts.Seconds, ts.Milliseconds)
        Console.WriteLine()

        initial = DateTime.Now
        For i = 0 To MaxCatalanNumber
            Console.WriteLine("CatalanNumber({0}:{1})", i, ThirdOption(i))
        Next
        final = DateTime.Now
        ts = final - initial
        Console.WriteLine("It took {0}.{1} to execute", ts.Seconds, ts.Milliseconds)
    End Sub

End Module
