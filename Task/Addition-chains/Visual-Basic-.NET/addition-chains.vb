Module Module1

    Function Prepend(n As Integer, seq As List(Of Integer)) As List(Of Integer)
        Dim result As New List(Of Integer) From {
            n
        }
        result.AddRange(seq)
        Return result
    End Function

    Function CheckSeq(pos As Integer, seq As List(Of Integer), n As Integer, min_len As Integer) As Tuple(Of Integer, Integer)
        If pos > min_len OrElse seq(0) > n Then
            Return Tuple.Create(min_len, 0)
        End If
        If seq(0) = n Then
            Return Tuple.Create(pos, 1)
        End If
        If pos < min_len Then
            Return TryPerm(0, pos, seq, n, min_len)
        End If
        Return Tuple.Create(min_len, 0)
    End Function

    Function TryPerm(i As Integer, pos As Integer, seq As List(Of Integer), n As Integer, min_len As Integer) As Tuple(Of Integer, Integer)
        If i > pos Then
            Return Tuple.Create(min_len, 0)
        End If

        Dim res1 = CheckSeq(pos + 1, Prepend(seq(0) + seq(i), seq), n, min_len)
        Dim res2 = TryPerm(i + 1, pos, seq, n, res1.Item1)

        If res2.Item1 < res1.Item1 Then
            Return res2
        End If
        If res2.Item1 = res1.Item1 Then
            Return Tuple.Create(res2.Item1, res1.Item2 + res2.Item2)
        End If

        Throw New Exception("TryPerm exception")
    End Function

    Function InitTryPerm(x As Integer) As Tuple(Of Integer, Integer)
        Return TryPerm(0, 0, New List(Of Integer) From {1}, x, 12)
    End Function

    Sub FindBrauer(num As Integer)
        Dim res = InitTryPerm(num)
        Console.WriteLine("N = {0}", num)
        Console.WriteLine("Minimum length of chains: L(n) = {0}", res.Item1)
        Console.WriteLine("Number of minimum length Brauer chains: {0}", res.Item2)
        Console.WriteLine()
    End Sub

    Sub Main()
        Dim nums() = {7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379}
        Array.ForEach(nums, Sub(n) FindBrauer(n))
    End Sub

End Module
