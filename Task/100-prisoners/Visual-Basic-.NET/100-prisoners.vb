Module Module1

    Function PlayOptimal() As Boolean
        Dim secrets = Enumerable.Range(0, 100).OrderBy(Function(a) Guid.NewGuid).ToList

        For p = 1 To 100
            Dim success = False

            Dim choice = p - 1
            For i = 1 To 50
                If secrets(choice) = p - 1 Then
                    success = True
                    Exit For
                End If
                choice = secrets(choice)
            Next

            If Not success Then
                Return False
            End If
        Next

        Return True
    End Function

    Function PlayRandom() As Boolean
        Dim secrets = Enumerable.Range(0, 100).OrderBy(Function(a) Guid.NewGuid).ToList

        For p = 1 To 100
            Dim choices = Enumerable.Range(0, 100).OrderBy(Function(a) Guid.NewGuid).ToList

            Dim success = False
            For i = 1 To 50
                If choices(i - 1) = p Then
                    success = True
                    Exit For
                End If
            Next

            If Not success Then
                Return False
            End If
        Next

        Return True
    End Function

    Function Exec(n As UInteger, play As Func(Of Boolean))
        Dim success As UInteger = 0
        For i As UInteger = 1 To n
            If play() Then
                success += 1
            End If
        Next
        Return 100.0 * success / n
    End Function

    Sub Main()
        Dim N = 1_000_000
        Console.WriteLine("# of executions: {0}", N)
        Console.WriteLine("Optimal play success rate: {0:0.00000000000}%", Exec(N, AddressOf PlayOptimal))
        Console.WriteLine(" Random play success rate: {0:0.00000000000}%", Exec(N, AddressOf PlayRandom))
    End Sub

End Module
