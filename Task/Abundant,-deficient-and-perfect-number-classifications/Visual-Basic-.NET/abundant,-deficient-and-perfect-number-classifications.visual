Module Module1

    Function SumProperDivisors(number As Integer) As Integer
        If number < 2 Then Return 0
        Dim sum As Integer = 0
        For i As Integer = 1 To number \ 2
            If number Mod i = 0 Then sum += i
        Next
        Return sum
    End Function

    Sub Main()
        Dim sum, deficient, perfect, abundant As Integer

        For n As Integer = 1 To 20000
            sum = SumProperDivisors(n)
            If sum < n Then
                deficient += 1
            ElseIf sum = n Then
                perfect += 1
            Else
                abundant += 1
            End If
        Next

        Console.WriteLine("The classification of the numbers from 1 to 20,000 is as follows : ")
        Console.WriteLine()
        Console.WriteLine("Deficient = {0}", deficient)
        Console.WriteLine("Perfect   = {0}", perfect)
        Console.WriteLine("Abundant  = {0}", abundant)
    End Sub

End Module
