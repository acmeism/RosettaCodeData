Module AscendingPrimes

    Function isPrime(n As Integer)
        n = Math.Abs(n)
        If n = 2 Then
            Return True
        End If
        If n = 1 Or n Mod 2 = 0 Then
            Return False
        End If
        Dim root As Integer = Math.Sqrt(n)
        For k = 3 To root Step 2
            If n Mod k = 0 Then
                Return False
            End If
        Next
        Return True
    End Function


    Sub Main()

        Dim queue As Queue(Of Integer) = New Queue(Of Integer)
        Dim primes As List(Of Integer) = New List(Of Integer)

        For k = 1 To 9
            queue.Enqueue(k)
        Next

        While queue.Count > 0
            Dim n As Integer = queue.Dequeue()
            If (isPrime(n)) Then
                primes.Add(n)
            End If
            For k = n Mod 10 + 1 To 9
                queue.Enqueue(n * 10 + k)
            Next
        End While

        For Each p As Integer In primes
            Console.Write(p)
            Console.Write(" ")
        Next
        Console.WriteLine()

    End Sub

End Module
