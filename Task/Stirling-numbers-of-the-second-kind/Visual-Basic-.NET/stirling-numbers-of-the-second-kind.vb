Imports System.Numerics

Module Module1

    Class Sterling
        Private Shared ReadOnly COMPUTED As New Dictionary(Of String, BigInteger)

        Private Shared Function CacheKey(n As Integer, k As Integer) As String
            Return String.Format("{0}:{1}", n, k)
        End Function

        Private Shared Function Impl(n As Integer, k As Integer) As BigInteger
            If n = 0 AndAlso k = 0 Then
                Return 1
            End If
            If (n > 0 AndAlso k = 0) OrElse (n = 0 AndAlso k > 0) Then
                Return 0
            End If
            If n = k Then
                Return 1
            End If
            If k > n Then
                Return 0
            End If

            Return k * Sterling2(n - 1, k) + Sterling2(n - 1, k - 1)
        End Function

        Public Shared Function Sterling2(n As Integer, k As Integer) As BigInteger
            Dim key = CacheKey(n, k)
            If COMPUTED.ContainsKey(key) Then
                Return COMPUTED(key)
            End If

            Dim result = Impl(n, k)
            COMPUTED.Add(key, result)
            Return result
        End Function
    End Class

    Sub Main()
        Console.WriteLine("Stirling numbers of the second kind:")
        Dim max = 12
        Console.Write("n/k")
        For n = 0 To max
            Console.Write("{0,10}", n)
        Next
        Console.WriteLine()
        For n = 0 To max
            Console.Write("{0,3}", n)
            For k = 0 To n
                Console.Write("{0,10}", Sterling.Sterling2(n, k))
            Next
            Console.WriteLine()
        Next
        Console.WriteLine("The maximum value of S2(100, k) = ")
        Dim previous = BigInteger.Zero
        For k = 1 To 100
            Dim current = Sterling.Sterling2(100, k)
            If current > previous Then
                previous = current
            Else
                Console.WriteLine(previous)
                Console.WriteLine("({0} digits, k = {1})", previous.ToString().Length, k - 1)
                Exit For
            End If
        Next
    End Sub

End Module
