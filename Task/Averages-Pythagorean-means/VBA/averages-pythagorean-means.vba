Private Function arithmetic_mean(s() As Variant) As Double
    arithmetic_mean = WorksheetFunction.Average(s)
End Function
Private Function geometric_mean(s() As Variant) As Double
    geometric_mean = WorksheetFunction.GeoMean(s)
End Function
Private Function harmonic_mean(s() As Variant) As Double
    harmonic_mean = WorksheetFunction.HarMean(s)
End Function
Public Sub pythagorean_means()
    Dim s() As Variant
    s = [{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}]
    Debug.Print "A ="; arithmetic_mean(s)
    Debug.Print "G ="; geometric_mean(s)
    Debug.Print "H ="; harmonic_mean(s)
End Sub
