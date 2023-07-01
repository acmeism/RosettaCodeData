Module Module1

    Function CountDivisors(n As Integer) As Integer
        If n < 2 Then
            Return 1
        End If
        Dim count = 2 '1 and n
        For i = 2 To n \ 2
            If n Mod i = 0 Then
                count += 1
            End If
        Next
        Return count
    End Function

    Sub Main()
        Dim maxDiv, count As Integer
        Console.WriteLine("The first 20 anti-primes are:")

        Dim n = 1
        While count < 20
            Dim d = CountDivisors(n)

            If d > maxDiv Then
                Console.Write("{0} ", n)
                maxDiv = d
                count += 1
            End If
            n += 1
        End While

        Console.WriteLine()
    End Sub

End Module
