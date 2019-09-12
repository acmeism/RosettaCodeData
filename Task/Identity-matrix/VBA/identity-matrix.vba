Private Function Identity(n As Integer) As Variant
    Dim I() As Integer
    ReDim I(n - 1, n - 1)
    For j = 0 To n - 1
        I(j, j) = 1
    Next j
    Identity = I
End Function
