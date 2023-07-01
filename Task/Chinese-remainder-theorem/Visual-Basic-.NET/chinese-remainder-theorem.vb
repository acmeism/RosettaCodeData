Module Module1

    Function ModularMultiplicativeInverse(a As Integer, m As Integer) As Integer
        Dim b = a Mod m
        For x = 1 To m - 1
            If (b * x) Mod m = 1 Then
                Return x
            End If
        Next
        Return 1
    End Function

    Function Solve(n As Integer(), a As Integer()) As Integer
        Dim prod = n.Aggregate(1, Function(i, j) i * j)
        Dim sm = 0
        Dim p As Integer
        For i = 0 To n.Length - 1
            p = prod / n(i)
            sm = sm + a(i) * ModularMultiplicativeInverse(p, n(i)) * p
        Next
        Return sm Mod prod
    End Function

    Sub Main()
        Dim n = {3, 5, 7}
        Dim a = {2, 3, 2}

        Dim result = Solve(n, a)

        Dim counter = 0
        Dim maxCount = n.Length - 1
        While counter <= maxCount
            Console.WriteLine($"{result} = {a(counter)} (mod {n(counter)})")
            counter = counter + 1
        End While
    End Sub

End Module
