Module Module1

    Sub Main()
        Dim i As Integer
        Console.WriteLine("Enter a number")
        i = Console.ReadLine()
        Console.WriteLine(words(i))
        Console.ReadLine()
    End Sub

    Function words(ByVal Number As Integer) As String
        Dim small() As String = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
         "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
         "eighteen", "nineteen"}
        Dim tens() As String = {"", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}
        Select Case Number
            Case Is < 20
                words = small(Number)
            Case 20 To 99
                words = tens(Number \ 10) + " " + small(Number Mod 10)
            Case 100 To 999
                words = small(Number \ 100) + " hundred " + IIf(((Number Mod 100) <> 0), "and ", "") + words(Number Mod 100)
            Case 1000
                words = "one thousand"
        End Select
    End Function

End Module
