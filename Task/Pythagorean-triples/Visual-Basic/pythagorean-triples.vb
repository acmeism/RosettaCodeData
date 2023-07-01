Option Explicit

Dim total As Long, prim As Long, maxPeri As Long

Public Sub NewTri(ByVal s0 As Long, ByVal s1 As Long, ByVal s2 As Long)
Dim p As Long, x1 As Long, x2 As Long
    p = s0 + s1 + s2
    If p <= maxPeri Then
        prim = prim + 1
        total = total + maxPeri \ p
        x1 = s0 + s2
        x2 = s1 + s2
        NewTri s0 + 2 * (-s1 + s2), 2 * x1 - s1, 2 * (x1 - s1) + s2
        NewTri s0 + 2 * x2, 2 * x1 + s1, 2 * (x1 + s1) + s2
        NewTri -s0 + 2 * x2, 2 * (-s0 + s2) + s1, 2 * (-s0 + x2) + s2
    End If
End Sub

Public Sub Main()
    maxPeri = 100
    Do While maxPeri <= 10& ^ 8
        prim = 0
        total = 0
        NewTri 3, 4, 5
        Debug.Print "Up to "; maxPeri; ": "; total; " triples, "; prim; " primitives."
        maxPeri = maxPeri * 10
    Loop
End Sub
