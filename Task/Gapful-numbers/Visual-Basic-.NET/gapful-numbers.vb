Module Module1

    Function FirstNum(n As Integer) As Integer
        REM Divide by ten until the leading digit remains.
        While n >= 10
            n /= 10
        End While
        Return n
    End Function

    Function LastNum(n As Integer) As Integer
        REM Modulo gives you the last digit.
        Return n Mod 10
    End Function

    Sub FindGap(n As Integer, gaps As Integer)
        Dim count = 0
        While count < gaps
            Dim i = FirstNum(n) * 10 + LastNum(n)

            REM Modulo with our new integer and output the result.
            If n Mod i = 0 Then
                Console.Write("{0} ", n)
                count += 1
            End If

            n += 1
        End While
        Console.WriteLine()
        Console.WriteLine()
    End Sub

    Sub Main()
        Console.WriteLine("The first 30 gapful numbers are: ")
        FindGap(100, 30)

        Console.WriteLine("The first 15 gapful numbers > 1,000,000 are: ")
        FindGap(1000000, 15)

        Console.WriteLine("The first 10 gapful numbers > 1,000,000,000 are: ")
        FindGap(1000000000, 10)
    End Sub

End Module
