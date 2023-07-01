Dim total As Variant, prim As Variant, maxPeri As Variant
Private Sub newTri(s0 As Variant, s1 As Variant, s2 As Variant)
    Dim p As Variant
    p = CDec(s0) + CDec(s1) + CDec(s2)
    If p <= maxPeri Then
        prim = prim + 1
        total = total + maxPeri \ p
        newTri s0 + 2 * (-s1 + s2), 2 * (s0 + s2) - s1, 2 * (s0 - s1 + s2) + s2
        newTri s0 + 2 * (s1 + s2), 2 * (s0 + s2) + s1, 2 * (s0 + s1 + s2) + s2
        newTri -s0 + 2 * (s1 + s2), 2 * (-s0 + s2) + s1, 2 * (-s0 + s1 + s2) + s2
      End If
End Sub
Public Sub Program_PythagoreanTriples()
    maxPeri = CDec(100)
    Do While maxPeri <= 10000000#
        prim = CDec(0)
        total = CDec(0)
        newTri 3, 4, 5
        Debug.Print "Up to "; maxPeri; ": "; total; " triples, "; prim; " primitives."
        maxPeri = maxPeri * 10
    Loop
End Sub
