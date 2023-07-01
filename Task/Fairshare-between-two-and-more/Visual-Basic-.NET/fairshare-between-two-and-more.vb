Module Module1

    Function Turn(base As Integer, n As Integer) As Integer
        Dim sum = 0
        While n <> 0
            Dim re = n Mod base
            n \= base
            sum += re
        End While
        Return sum Mod base
    End Function

    Sub Fairshare(base As Integer, count As Integer)
        Console.Write("Base {0,2}:", base)
        For i = 1 To count
            Dim t = Turn(base, i - 1)
            Console.Write(" {0,2}", t)
        Next
        Console.WriteLine()
    End Sub

    Sub TurnCount(base As Integer, count As Integer)
        Dim cnt(base) As Integer
        For i = 1 To base
            cnt(i - 1) = 0
        Next

        For i = 1 To count
            Dim t = Turn(base, i - 1)
            cnt(t) += 1
        Next

        Dim minTurn = Integer.MaxValue
        Dim maxTurn = Integer.MinValue
        Dim portion = 0
        For i = 1 To base
            Dim num = cnt(i - 1)
            If num > 0 Then
                portion += 1
            End If
            If num < minTurn Then
                minTurn = num
            End If
            If num > maxTurn Then
                maxTurn = num
            End If
        Next

        Console.Write("  With {0} people: ", base)
        If 0 = minTurn Then
            Console.WriteLine("Only {0} have a turn", portion)
        ElseIf minTurn = maxTurn Then
            Console.WriteLine(minTurn)
        Else
            Console.WriteLine("{0} or {1}", minTurn, maxTurn)
        End If
    End Sub

    Sub Main()
        Fairshare(2, 25)
        Fairshare(3, 25)
        Fairshare(5, 25)
        Fairshare(11, 25)

        Console.WriteLine("How many times does each get a turn in 50000 iterations?")
        TurnCount(191, 50000)
        TurnCount(1377, 50000)
        TurnCount(49999, 50000)
        TurnCount(50000, 50000)
        TurnCount(50001, 50000)
    End Sub

End Module
