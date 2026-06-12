Module Module1

    Function FindCycle(Of T As IEquatable(Of T))(x0 As T, yielder As Func(Of T, T)) As Tuple(Of Integer, Integer)
        Dim power = 1
        Dim lambda = 1
        Dim tortoise As T
        Dim hare As T

        tortoise = x0
        hare = yielder(x0)

        ' Find lambda, the cycle length
        While Not tortoise.Equals(hare)
            If power = lambda Then
                tortoise = hare
                power *= 2
                lambda = 0
            End If
            hare = yielder(hare)
            lambda += 1
        End While

        ' Find mu, the zero-based index of the start of the cycle
        Dim mu = 0
        tortoise = x0
        hare = x0
        For times = 1 To lambda
            hare = yielder(hare)
        Next

        While Not tortoise.Equals(hare)
            tortoise = yielder(tortoise)
            hare = yielder(hare)
            mu += 1
        End While

        Return Tuple.Create(lambda, mu)
    End Function

    Sub Main()
        ' A recurrence relation to use in testing
        Dim sequence = Function(_x As Integer) (_x * _x + 1) Mod 255

        ' Display the first 41 numbers in the test series
        Dim x = 3
        Console.Write(x)
        For times = 0 To 39
            x = sequence(x)
            Console.Write(",{0}", x)
        Next
        Console.WriteLine()

        ' Test the FindCycle method
        Dim cycle = FindCycle(3, sequence)
        Console.WriteLine("Cycle length = {0}", cycle.Item1)
        Console.WriteLine("Start index = {0}", cycle.Item2)
    End Sub

End Module
