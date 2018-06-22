Private Function SumMult3and5(n As Double) As Double
Dim i As Double
    For i = 3 To n - 1 Step 3
        SumMult3and5 = SumMult3and5 + i
    Next
    For i = 5 To n - 1 Step 5
        If i Mod 15 <> 0 Then SumMult3and5 = SumMult3and5 + i
    Next
End Function
