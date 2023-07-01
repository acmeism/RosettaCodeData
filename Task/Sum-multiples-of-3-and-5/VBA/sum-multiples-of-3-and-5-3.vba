Private Function SumMult3and5BETTER(n As Double) As Double
Dim i As Double
    For i = 3 To n - 1 Step 3
        SumMult3and5BETTER = SumMult3and5BETTER + i
    Next
    For i = 5 To n - 1 Step 5
        SumMult3and5BETTER = SumMult3and5BETTER + i
    Next
    For i = 15 To n - 1 Step 15
        SumMult3and5BETTER = SumMult3and5BETTER - i
    Next
End Function
