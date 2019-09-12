Module HappyNumbers
    Sub Main()
        Dim n As Integer = 1
        Dim found As Integer = 0

        Do Until found = 8
            If IsHappy(n) Then
                found += 1
                Console.WriteLine("{0}: {1}", found, n)
            End If
            n += 1
        Loop

        Console.ReadLine()
    End Sub

    Private Function IsHappy(ByVal n As Integer)
        Dim cache As New List(Of Long)()

        Do Until n = 1
            cache.Add(n)
            n = Aggregate c In n.ToString() _
                Into Total = Sum(Int32.Parse(c) ^ 2)
            If cache.Contains(n) Then Return False
        Loop

        Return True
    End Function
End Module
