Module Module1

    ReadOnly SNL As New Dictionary(Of Integer, Integer) From {
        {4, 14},
        {9, 31},
        {17, 7},
        {20, 38},
        {28, 84},
        {40, 59},
        {51, 67},
        {54, 34},
        {62, 19},
        {63, 81},
        {64, 60},
        {71, 91},
        {87, 24},
        {93, 73},
        {95, 75},
        {99, 78}
    }
    ReadOnly rand As New Random
    Const sixesThrowAgain = True

    Function Turn(player As Integer, square As Integer) As Integer
        Do
            Dim roll = rand.Next(1, 6)
            Console.Write("Player {0}, on square {1}, rolls a {2}", player, square, roll)
            If square + roll > 100 Then
                Console.WriteLine(" but cannot move.")
            Else
                square += roll
                Console.WriteLine(" and moves to square {0}", square)
                If square = 100 Then
                    Return 100
                End If

                Dim nxt = square
                If SNL.ContainsKey(square) Then
                    nxt = SNL(nxt)
                End If
                If square < nxt Then
                    Console.WriteLine("Yay! Landed on a ladder. Climb up to {0}.", nxt)
                    If nxt = 100 Then
                        Return 100
                    End If
                    square = nxt
                ElseIf square > nxt Then
                    Console.WriteLine("Oops! Landed on a snake. Slither down to {0}.", nxt)
                    square = nxt
                End If
            End If

            If roll < 6 OrElse Not sixesThrowAgain Then
                Return square
            End If
            Console.WriteLine("Rolled a 6 so roll again.")
        Loop
    End Function

    Sub Main()
        Dim players = {1, 1, 1}
        Do
            For i = 1 To players.Length
                Dim ns = Turn(i, players(i - 1))
                If ns = 100 Then
                    Console.WriteLine("Player {0} wins!", i)
                    Return
                End If
                players(i - 1) = ns
                Console.WriteLine()
            Next
        Loop
    End Sub

End Module
