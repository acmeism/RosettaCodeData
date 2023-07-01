Private Function agm(a As Double, g As Double, Optional tolerance As Double = 0.000000000000001) As Double
    Do While Abs(a - g) > tolerance
        tmp = a
        a = (a + g) / 2
        g = Sqr(tmp * g)
        Debug.Print a
    Loop
    agm = a
End Function
Public Sub main()
    Debug.Print agm(1, 1 / Sqr(2))
End Sub
