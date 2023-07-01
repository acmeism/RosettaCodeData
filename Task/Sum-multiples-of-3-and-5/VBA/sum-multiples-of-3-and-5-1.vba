Private Function SumMult3and5VBScript(n As Double) As Double
Dim i As Double
    For i = 1 To n - 1
        If i Mod 3 = 0 Or i Mod 5 = 0 Then
            SumMult3and5VBScript = SumMult3and5VBScript + i
        End If
    Next
End Function
