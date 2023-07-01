Option Base 1
Private Function mean(s() As Variant) As Double
    mean = WorksheetFunction.Average(s)
End Function
Private Function standard_deviation(s() As Variant) As Double
    standard_deviation = WorksheetFunction.StDev(s)
End Function
Public Sub basic_statistics()
    Dim s() As Variant
    For e = 2 To 4
        ReDim s(10 ^ e)
        For i = 1 To 10 ^ e
            s(i) = Rnd()
        Next i
        Debug.Print "sample size"; UBound(s), "mean"; mean(s), "standard deviation"; standard_deviation(s)
        t = WorksheetFunction.Frequency(s, [{0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}])
        For i = 1 To 10
            Debug.Print Format((i - 1) / 10, "0.00");
            Debug.Print "-"; Format(i / 10, "0.00"),
            Debug.Print String$(t(i, 1) / (10 ^ (e - 2)), "X");
            Debug.Print
        Next i
        Debug.Print
    Next e
End Sub
