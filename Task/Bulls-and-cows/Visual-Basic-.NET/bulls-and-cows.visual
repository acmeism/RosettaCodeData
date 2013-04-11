Imports System
Imports System.Text.RegularExpressions

Module Bulls_and_Cows
    Function CreateNumber() As String
        Dim random As New Random()
        Dim sequence As Char() = {"1"c, "2"c, "3"c, "4"c, "5"c, "6"c, "7"c, "8"c, "9"c}

        For i As Integer = 0 To sequence.Length - 1
            Dim j As Integer = random.Next(sequence.Length)
            Dim temp As Char = sequence(i) : sequence(i) = sequence(j) : sequence(j) = temp
        Next

        Return New String(sequence, 0, 4)
    End Function

    Function IsFourDigitNumber(ByVal number As String) As Boolean
        Return Regex.IsMatch(number, "^[1-9]{4}$")
    End Function

    Sub Main()
        Dim chosenNumber As String = CreateNumber()
        Dim attempt As Integer = 0
        Console.WriteLine("Number is chosen")
        Dim gameOver As Boolean = False
        Do
            attempt += 1
            Console.WriteLine("Attempt #{0}. Enter four digit number: ", attempt)
            Dim number As String = Console.ReadLine()
            Do While Not IsFourDigitNumber(number)
                Console.WriteLine("Invalid number: type four characters. Every character must digit be between '1' and '9'.")
                number = Console.ReadLine()
            Loop

            Dim bulls As Integer = 0
            Dim cows As Integer = 0

            For i As Integer = 0 To number.Length - 1
                Dim j As Integer = chosenNumber.IndexOf(number(i))
                If i = j Then
                    bulls += 1
                ElseIf j >= 0 Then
                    cows += 1
                End If
            Next

            If bulls < chosenNumber.Length Then
                Console.WriteLine("The number '{0}' has {1} bulls and {2} cows", _
                    number, bulls, cows)
            Else
                gameOver = True
            End If
        Loop Until gameOver
        Console.WriteLine("The number was guessed in {0} attempts. Congratulations!", attempt)
    End Sub
End Module
