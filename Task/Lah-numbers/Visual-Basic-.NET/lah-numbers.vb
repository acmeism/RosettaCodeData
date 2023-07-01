Imports System.Numerics

Module Module1

    Function Factorial(n As BigInteger) As BigInteger
        If n = 0 Then
            Return 1
        End If

        Dim res As BigInteger = 1
        While n > 0
            res *= n
            n -= 1
        End While
        Return res
    End Function

    Function Lah(n As BigInteger, k As BigInteger) As BigInteger
        If k = 1 Then
            Return Factorial(n)
        End If
        If k = n Then
            Return 1
        End If
        If k > n Then
            Return 0
        End If
        If k < 1 OrElse n < 1 Then
            Return 0
        End If
        Return (Factorial(n) * Factorial(n - 1)) / (Factorial(k) * Factorial(k - 1)) / Factorial(n - k)
    End Function

    Sub Main()
        Console.WriteLine("Unsigned Lah numbers: L(n, k):")
        Console.Write("n/k ")
        For Each i In Enumerable.Range(0, 13)
            Console.Write("{0,10} ", i)
        Next
        Console.WriteLine()

        For Each row In Enumerable.Range(0, 13)
            Console.Write("{0,-3}", row)
            For Each i In Enumerable.Range(0, row + 1)
                Dim l = Lah(row, i)
                Console.Write("{0,11}", l)
            Next
            Console.WriteLine()
        Next
        Console.WriteLine()

        Console.WriteLine("Maximum value from the L(100, *) row:")
        Dim maxVal = Enumerable.Range(0, 100).Select(Function(a) Lah(100, a)).Max
        Console.WriteLine(maxVal)
    End Sub

End Module
