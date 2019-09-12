Private Function root_mean_square(s() As Variant) As Double
    For i = 1 To UBound(s)
        s(i) = s(i) ^ 2
    Next i
    root_mean_square = Sqr(WorksheetFunction.sum(s) / UBound(s))
End Function
Public Sub pythagorean_means()
    Dim s() As Variant
    s = [{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}]
    Debug.Print root_mean_square(s)
End Sub
