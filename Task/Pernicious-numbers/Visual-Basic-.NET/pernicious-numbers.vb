Module Module1

    Function PopulationCount(n As Long) As Integer
        Dim cnt = 0
        Do
            If (n Mod 2) <> 0 Then
                cnt += 1
            End If
            n >>= 1
        Loop While n > 0
        Return cnt
    End Function

    Function IsPrime(x As Integer) As Boolean
        If x <= 2 OrElse (x Mod 2) = 0 Then
            Return x = 2
        End If

        Dim limit = Math.Sqrt(x)
        For i = 3 To limit Step 2
            If x Mod i = 0 Then
                Return False
            End If
        Next

        Return True
    End Function

    Function Pernicious(start As Integer, count As Integer, take As Integer) As IEnumerable(Of Integer)
        Return Enumerable.Range(start, count).Where(Function(n) IsPrime(PopulationCount(n))).Take(take)
    End Function

    Sub Main()
        For Each n In Pernicious(0, Integer.MaxValue, 25)
            Console.Write("{0} ", n)
        Next
        Console.WriteLine()

        For Each n In Pernicious(888888877, 11, 11)
            Console.Write("{0} ", n)
        Next
        Console.WriteLine()
    End Sub

End Module
