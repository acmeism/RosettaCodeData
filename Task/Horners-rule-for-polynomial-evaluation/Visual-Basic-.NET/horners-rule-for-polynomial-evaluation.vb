Module Module1

    Function Horner(coefficients As Double(), variable As Double) As Double
        Return coefficients.Reverse().Aggregate(Function(acc, coeff) acc * variable + coeff)
    End Function

    Sub Main()
        Console.WriteLine(Horner({-19.0, 7.0, -4.0, 6.0}, 3.0))
    End Sub

End Module
