Module Module1

    Function KahanSum(ParamArray fa As Single()) As Single
        Dim sum = 0.0F
        Dim c = 0.0F
        For Each f In fa
            Dim y = f - c
            Dim t = sum + y
            c = (t - sum) - y
            sum = t
        Next
        Return sum
    End Function

    Function Epsilon() As Single
        Dim eps = 1.0F
        While 1.0F + eps <> 1.0F
            eps /= 2.0F
        End While
        Return eps
    End Function

    Sub Main()
        Dim a = 1.0F
        Dim b = Epsilon()
        Dim c = -b
        Console.WriteLine("Epsilon      = {0}", b)
        Console.WriteLine("(a + b) + c  = {0}", (a + b) + c)
        Console.WriteLine("Kahan sum    = {0}", KahanSum(a, b, c))
    End Sub

End Module
