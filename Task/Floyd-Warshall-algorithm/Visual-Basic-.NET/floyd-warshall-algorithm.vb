Module Module1

    Sub PrintResult(dist As Double(,), nxt As Integer(,))
        Console.WriteLine("pair     dist    path")
        For i = 1 To nxt.GetLength(0)
            For j = 1 To nxt.GetLength(1)
                If i <> j Then
                    Dim u = i
                    Dim v = j
                    Dim path = String.Format("{0} -> {1}    {2,2:G}     {3}", u, v, dist(i - 1, j - 1), u)
                    Do
                        u = nxt(u - 1, v - 1)
                        path += String.Format(" -> {0}", u)
                    Loop While u <> v
                    Console.WriteLine(path)
                End If
            Next
        Next
    End Sub

    Sub FloydWarshall(weights As Integer(,), numVerticies As Integer)
        Dim dist(numVerticies - 1, numVerticies - 1) As Double
        For i = 1 To numVerticies
            For j = 1 To numVerticies
                dist(i - 1, j - 1) = Double.PositiveInfinity
            Next
        Next

        For i = 1 To weights.GetLength(0)
            dist(weights(i - 1, 0) - 1, weights(i - 1, 1) - 1) = weights(i - 1, 2)
        Next

        Dim nxt(numVerticies - 1, numVerticies - 1) As Integer
        For i = 1 To numVerticies
            For j = 1 To numVerticies
                If i <> j Then
                    nxt(i - 1, j - 1) = j
                End If
            Next
        Next

        For k = 1 To numVerticies
            For i = 1 To numVerticies
                For j = 1 To numVerticies
                    If dist(i - 1, k - 1) + dist(k - 1, j - 1) < dist(i - 1, j - 1) Then
                        dist(i - 1, j - 1) = dist(i - 1, k - 1) + dist(k - 1, j - 1)
                        nxt(i - 1, j - 1) = nxt(i - 1, k - 1)
                    End If
                Next
            Next
        Next

        PrintResult(dist, nxt)
    End Sub

    Sub Main()
        Dim weights = {{1, 3, -2}, {2, 1, 4}, {2, 3, 3}, {3, 4, 2}, {4, 2, -1}}
        Dim numVeritices = 4

        FloydWarshall(weights, numVeritices)
    End Sub

End Module
