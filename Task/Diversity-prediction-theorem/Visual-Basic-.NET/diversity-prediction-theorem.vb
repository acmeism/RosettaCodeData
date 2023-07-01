Module Module1

    Function Square(x As Double) As Double
        Return x * x
    End Function

    Function AverageSquareDiff(a As Double, predictions As IEnumerable(Of Double)) As Double
        Return predictions.Select(Function(x) Square(x - a)).Average()
    End Function

    Sub DiversityTheorem(truth As Double, predictions As IEnumerable(Of Double))
        Dim average = predictions.Average()
        Console.WriteLine("average-error: {0}", AverageSquareDiff(truth, predictions))
        Console.WriteLine("crowd-error: {0}", Square(truth - average))
        Console.WriteLine("diversity: {0}", AverageSquareDiff(average, predictions))
    End Sub

    Sub Main()
        DiversityTheorem(49.0, {48.0, 47.0, 51.0})
        DiversityTheorem(49.0, {48.0, 47.0, 51.0, 42.0})
    End Sub

End Module
