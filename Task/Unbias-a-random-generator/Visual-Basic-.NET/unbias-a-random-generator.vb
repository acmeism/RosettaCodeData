Module Module1
    Dim random As New Random()

    Function RandN(n As Integer) As Boolean
        Return random.Next(0, n) = 0
    End Function

    Function Unbiased(n As Integer) As Boolean
        Dim flip1 As Boolean
        Dim flip2 As Boolean

        Do
            flip1 = RandN(n)
            flip2 = RandN(n)
        Loop While flip1 = flip2

        Return flip1
    End Function

    Sub Main()
        For n = 3 To 6
            Dim biasedZero = 0
            Dim biasedOne = 0
            Dim unbiasedZero = 0
            Dim unbiasedOne = 0
            For i = 1 To 100000
                If RandN(n) Then
                    biasedOne += 1
                Else
                    biasedZero += 1
                End If
                If Unbiased(n) Then
                    unbiasedOne += 1
                Else
                    unbiasedZero += 1
                End If
            Next

            Console.WriteLine("(N = {0}):".PadRight(17) + "# of 0" + vbTab + "# of 1" + vbTab + "% of 0" + vbTab + "% of 1", n)
            Console.WriteLine("(Biased: {0}):".PadRight(15) + "{0}" + vbTab + "{1}" + vbTab + "{2}" + vbTab + "{3}", biasedZero, biasedOne, biasedZero / 1000, biasedOne / 1000)
            Console.WriteLine("(UnBiased: {0}):".PadRight(15) + "{0}" + vbTab + "{1}" + vbTab + "{2}" + vbTab + "{3}", unbiasedZero, unbiasedOne, unbiasedZero / 1000, unbiasedOne / 1000)
        Next
    End Sub

End Module
