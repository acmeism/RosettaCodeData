Public Sub standard_normal()
    Dim s() As Variant, bins(71) As Single
    ReDim s(20000)
    For i = 1 To 20000
        s(i) = WorksheetFunction.Norm_S_Inv(Rnd())
    Next i
    For i = -35 To 35
        bins(i + 36) = i / 10
    Next i
    Debug.Print "sample size"; UBound(s), "mean"; mean(s), "standard deviation"; standard_deviation(s)
            t = WorksheetFunction.Frequency(s, bins)
    For i = -35 To 35
        Debug.Print Format((i - 1) / 10, "0.00");
        Debug.Print "-"; Format(i / 10, "0.00"),
        Debug.Print String$(t(i + 36, 1) / 10, "X");
        Debug.Print
    Next i
End Sub
