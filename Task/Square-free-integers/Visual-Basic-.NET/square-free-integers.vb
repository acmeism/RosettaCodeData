Module Module1

    Function Sieve(limit As Long) As List(Of Long)
        Dim primes As New List(Of Long) From {2}
        Dim c(limit + 1) As Boolean
        Dim p = 3L
        While True
            Dim p2 = p * p
            If p2 > limit Then
                Exit While
            End If
            For i = p2 To limit Step 2 * p
                c(i) = True
            Next
            While True
                p += 2
                If Not c(p) Then
                    Exit While
                End If
            End While
        End While
        For i = 3 To limit Step 2
            If Not c(i) Then
                primes.Add(i)
            End If
        Next
        Return primes
    End Function

    Function SquareFree(from As Long, to_ As Long) As List(Of Long)
        Dim limit = CType(Math.Sqrt(to_), Long)
        Dim primes = Sieve(limit)
        Dim results As New List(Of Long)

        Dim i = from
        While i <= to_
            For Each p In primes
                Dim p2 = p * p
                If p2 > i Then
                    Exit For
                End If
                If (i Mod p2) = 0 Then
                    i += 1
                    Continue While
                End If
            Next
            results.Add(i)
            i += 1
        End While

        Return results
    End Function

    ReadOnly TRILLION As Long = 1_000_000_000_000

    Sub Main()
        Console.WriteLine("Square-free integers from 1 to 145:")
        Dim sf = SquareFree(1, 145)
        For index = 0 To sf.Count - 1
            Dim v = sf(index)
            If index > 1 AndAlso (index Mod 20) = 0 Then
                Console.WriteLine()
            End If
            Console.Write("{0,4}", v)
        Next
        Console.WriteLine()
        Console.WriteLine()

        Console.WriteLine("Square-free integers from {0} to {1}:", TRILLION, TRILLION + 145)
        sf = SquareFree(TRILLION, TRILLION + 145)
        For index = 0 To sf.Count - 1
            Dim v = sf(index)
            If index > 1 AndAlso (index Mod 5) = 0 Then
                Console.WriteLine()
            End If
            Console.Write("{0,14}", v)
        Next
        Console.WriteLine()
        Console.WriteLine()

        Console.WriteLine("Number of square-free integers:")
        For Each to_ In {100, 1_000, 10_000, 100_000, 1_000_000}
            Console.WriteLine("   from 1 to {0} = {1}", to_, SquareFree(1, to_).Count)
        Next
    End Sub

End Module
