Public Class CirclesOfGivenRadiusThroughTwoPoints
    Public Shared Sub Main()
        For Each valu In New Double()() {
        New Double() {0.1234, 0.9876, 0.8765, 0.2345, 2},
        New Double() {0.0, 2.0, 0.0, 0.0, 1},
        New Double() {0.1234, 0.9876, 0.1234, 0.9876, 2},
        New Double() {0.1234, 0.9876, 0.8765, 0.2345, 0.5},
        New Double() {0.1234, 0.9876, 0.1234, 0.9876, 0},
        New Double() {0.1234, 0.9876, 0.2345, 0.8765, 0}}
            Dim p = New Point(valu(0), valu(1)), q = New Point(valu(2), valu(3))
            Console.WriteLine($"Points {p} and {q} with radius {valu(4)}:")
            Try
                Console.WriteLine(vbTab & String.Join(" and ", FindCircles(p, q, valu(4))))
            Catch ex As Exception
                Console.WriteLine(vbTab & ex.Message)
            End Try
        Next
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub

    Private Shared Function FindCircles(ByVal p As Point, ByVal q As Point, ByVal rad As Double) As Point()
        If rad < 0 Then Throw New ArgumentException("Negative radius.")
        If rad = 0 Then Throw New InvalidOperationException(If(p = q,
            String.Format("{0} (degenerate circle)", {p}), "No circles."))
        If p = q Then Throw New InvalidOperationException("Infinite number of circles.")
        Dim dist As Double = Point.Distance(p, q), sqDist As Double = dist * dist,
            sqDiam As Double = 4 * rad * rad
        If sqDist > sqDiam Then Throw New InvalidOperationException(
            String.Format("Points are too far apart (by {0}).", sqDist - sqDiam))
        Dim midPoint As Point = New Point((p.X + q.X) / 2, (p.Y + q.Y) / 2)
        If sqDist = sqDiam Then Return {midPoint}
        Dim d As Double = Math.Sqrt(rad * rad - sqDist / 4),
            a As Double = d * (q.X - p.X) / dist, b As Double = d * (q.Y - p.Y) / dist
        Return {New Point(midPoint.X - b, midPoint.Y + a), New Point(midPoint.X + b, midPoint.Y - a)}
    End Function

    Public Structure Point
        Public ReadOnly Property X As Double
        Public ReadOnly Property Y As Double

        Public Sub New(ByVal ix As Double, ByVal iy As Double)
            Me.New() : X = ix : Y = iy
        End Sub

        Public Shared Operator =(ByVal p As Point, ByVal q As Point) As Boolean
            Return p.X = q.X AndAlso p.Y = q.Y
        End Operator

        Public Shared Operator <>(ByVal p As Point, ByVal q As Point) As Boolean
            Return p.X <> q.X OrElse p.Y <> q.Y
        End Operator

        Public Shared Function SquaredDistance(ByVal p As Point, ByVal q As Point) As Double
            Dim dx As Double = q.X - p.X, dy As Double = q.Y - p.Y
            Return dx * dx + dy * dy
        End Function

        Public Shared Function Distance(ByVal p As Point, ByVal q As Point) As Double
            Return Math.Sqrt(SquaredDistance(p, q))
        End Function

        Public Overrides Function ToString() As String
            Return $"({X}, {Y})"
        End Function
    End Structure
End Class
