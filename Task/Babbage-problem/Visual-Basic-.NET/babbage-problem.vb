Module Module1

    Function Right6Digits(num As Long) As Long
        Dim asString = num.ToString()
        If asString.Length < 6 Then
            Return num
        End If

        Dim last6 = asString.Substring(asString.Length - 6)
        Return Long.Parse(last6)
    End Function

    Sub Main()
        Dim bnSq = 0    'the base number squared
        Dim bn = 0      'the number to be squared

        Do
            bn = bn + 1
            bnSq = bn * bn
        Loop While Right6Digits(bnSq) <> 269696

        Console.WriteLine("The smallest integer whose square ends in 269,696 is {0}", bn)
        Console.WriteLine("The square is {0}", bnSq)
    End Sub

End Module
