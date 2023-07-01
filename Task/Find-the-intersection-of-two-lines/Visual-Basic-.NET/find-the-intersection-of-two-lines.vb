Imports System.Drawing

Module Module1

    Function FindIntersection(s1 As PointF, e1 As PointF, s2 As PointF, e2 As PointF) As PointF
        Dim a1 = e1.Y - s1.Y
        Dim b1 = s1.X - e1.X
        Dim c1 = a1 * s1.X + b1 * s1.Y

        Dim a2 = e2.Y - s2.Y
        Dim b2 = s2.X - e2.X
        Dim c2 = a2 * s2.X + b2 * s2.Y

        Dim delta = a1 * b2 - a2 * b1

        'If lines are parallel, the result will be (NaN, NaN).
        Return If(delta = 0, New PointF(Single.NaN, Single.NaN), New PointF((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta))
    End Function

    Sub Main()
        Dim p = Function(x As Single, y As Single) New PointF(x, y)
        Console.WriteLine(FindIntersection(p(4.0F, 0F), p(6.0F, 10.0F), p(0F, 3.0F), p(10.0F, 7.0F)))
        Console.WriteLine(FindIntersection(p(0F, 0F), p(1.0F, 1.0F), p(1.0F, 2.0F), p(4.0F, 5.0F)))
    End Sub

End Module
