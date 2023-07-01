Module AbundantOddNumbers
    ' find some abundant odd numbers - numbers where the sum of the proper
    '                                  divisors is bigger than the number
    '                                  itself

    ' returns the sum of the proper divisors of n
    Private Function divisorSum(n As Integer) As Integer
        Dim sum As Integer = 1
        For d As Integer = 2 To Math.Round(Math.Sqrt(n))
            If n Mod d = 0 Then
                sum += d
                Dim otherD As Integer = n \ d
                IF otherD <> d Then
                    sum += otherD
                End If
            End If
        Next d
        Return sum
    End Function

    ' find numbers required by the task
    Public Sub Main(args() As String)
        ' first 25 odd abundant numbers
        Dim oddNumber As Integer = 1
        Dim aCount As Integer = 0
        Dim dSum As Integer = 0
        Console.Out.WriteLine("The first 25 abundant odd numbers:")
        Do While aCount < 25
            dSum = divisorSum(oddNumber)
            If dSum > oddNumber Then
                aCount += 1
                Console.Out.WriteLine(oddNumber.ToString.PadLeft(6) & " proper divisor sum: " & dSum)
            End If
            oddNumber += 2
        Loop
        ' 1000th odd abundant number
        Do While aCount < 1000
            dSum = divisorSum(oddNumber)
            If dSum > oddNumber Then
                aCount += 1
            End If
            oddNumber += 2
        Loop
        Console.Out.WriteLine("1000th abundant odd number:")
        Console.Out.WriteLine("    " & (oddNumber - 2) & " proper divisor sum: " & dSum)
        ' first odd abundant number > one billion
        oddNumber = 1000000001
        Dim found As Boolean = False
        Do While Not found
            dSum = divisorSum(oddNumber)
            If dSum > oddNumber Then
                found = True
                Console.Out.WriteLine("First abundant odd number > 1 000 000 000:")
                Console.Out.WriteLine("    " & oddNumber & " proper divisor sum: " & dSum)
            End If
            oddNumber += 2
        Loop
    End Sub
End Module
