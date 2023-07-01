Module Module1

    Sub Main()
        Dim str As String
        Dim num As Integer
        While True
            Console.Write("Enter an integer or 0 to finish: ")
            str = Console.ReadLine()
            If Integer.TryParse(str, num) Then
                If num = 0 Then
                    Exit While
                End If
                If num Mod 2 = 0 Then
                    Console.WriteLine("Even")
                Else
                    Console.WriteLine("Odd")
                End If
            Else
                Console.WriteLine("Bad input.")
            End If
        End While
    End Sub

End Module
