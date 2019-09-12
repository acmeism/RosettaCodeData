Module Guess_the_Number
    Sub Main()
        Dim random As New Random()
        Dim secretNum As Integer = random.Next(10) + 1
        Dim gameOver As Boolean = False
        Console.WriteLine("I am thinking of a number from 1 to 10. Can you guess it?")
        Do
            Dim guessNum As Integer
            Console.Write("Enter your guess: ")

            If Not Integer.TryParse(Console.ReadLine(), guessNum) Then
                Console.WriteLine("You should enter a number from 1 to 10. Try again!")
                Continue Do
            End If

            If guessNum = secretNum Then
                Console.WriteLine("Well guessed!")
                gameOver = True
            Else
                Console.WriteLine("Incorrect. Try again!")
            End If
        Loop Until gameOver
    End Sub
End Module
