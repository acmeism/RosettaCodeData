Option Explicit

Private Type MyPoint
    X As Single
    Y As Single
End Type

Private Type MyPair
    p1 As MyPoint
    p2 As MyPoint
End Type

Sub Main()
Dim points() As MyPoint, i As Long, BF As MyPair, d As Single, Nb As Long
Dim T#
Randomize Timer
    Nb = 10
    Do
        ReDim points(1 To Nb)
        For i = 1 To Nb
            points(i).X = Rnd * Nb
            points(i).Y = Rnd * Nb
        Next
        d = 1000000000000#
T = Timer
        BF = BruteForce(points, d)
        Debug.Print "For " & Nb & " points, runtime : " & Timer - T & " sec."
        Debug.Print "point 1 : X:" & BF.p1.X & " Y:" & BF.p1.Y
        Debug.Print "point 2 : X:" & BF.p2.X & " Y:" & BF.p2.Y
        Debug.Print "dist : " & d
        Debug.Print "--------------------------------------------------"
        Nb = Nb * 10
    Loop While Nb <= 10000
End Sub

Private Function BruteForce(p() As MyPoint, mindist As Single) As MyPair
Dim i As Long, j As Long, d As Single, ClosestPair As MyPair
    For i = 1 To UBound(p) - 1
        For j = i + 1 To UBound(p)
            d = Dist(p(i), p(j))
            If d < mindist Then
                mindist = d
                ClosestPair.p1 = p(i)
                ClosestPair.p2 = p(j)
            End If
        Next
    Next
    BruteForce = ClosestPair
End Function

Private Function Dist(p1 As MyPoint, p2 As MyPoint) As Single
    Dist = Sqr((p1.X - p2.X) ^ 2 + (p1.Y - p2.Y) ^ 2)
End Function
