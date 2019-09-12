Module Module1

    Class KPrime
        Public K As Integer

        Public Function IsKPrime(number As Integer) As Boolean
            Dim primes = 0
            Dim p = 2
            While p * p <= number AndAlso primes < K
                While number Mod p = 0 AndAlso primes < K
                    number = number / p
                    primes = primes + 1
                End While
                p = p + 1
            End While
            If number > 1 Then
                primes = primes + 1
            End If
            Return primes = K
        End Function

        Public Function GetFirstN(n As Integer) As List(Of Integer)
            Dim result As New List(Of Integer)
            Dim number = 2
            While result.Count < n
                If IsKPrime(number) Then
                    result.Add(number)
                End If
                number = number + 1
            End While
            Return result
        End Function
    End Class

    Sub Main()
        For Each k In Enumerable.Range(1, 5)
            Dim kprime = New KPrime With {
                .K = k
            }
            Console.WriteLine("k = {0}: {1}", k, String.Join(" ", kprime.GetFirstN(10)))
        Next
    End Sub

End Module
