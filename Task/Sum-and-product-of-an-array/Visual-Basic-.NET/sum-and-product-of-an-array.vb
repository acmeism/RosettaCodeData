Module Program
    Sub Main()
        Dim arg As Integer() = {1, 2, 3, 4, 5}
        Dim sum = arg.Sum()
        Dim prod = arg.Aggregate(Function(runningProduct, nextFactor) runningProduct * nextFactor)
    End Sub
End Module
