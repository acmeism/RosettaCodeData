Sub BernoullisTriangleRow(Byval n As Integer, row() As Integer)
    Dim As Integer i, j, k, s
    Redim row(0 To n)
    For k = 0 To n
        s = 0
        For i = 0 To k
            Dim As Integer coeff = 1
            For j = 1 To i
                coeff = coeff * (n - j + 1) \ j
            Next j
            s += coeff
        Next i
        row(k) = s
    Next k
End Sub

' Main program
Dim As Integer lim = 15
Dim As Integer n, k
Dim row() As Integer
For n = 0 To lim - 1
    BernoullisTriangleRow(n, row())
    For k = 0 To Ubound(row)
        Print row(k); Space(5- Len(row(k)));
    Next k
    Print
Next n

Sleep
