Module Module1

    Structure Point
        Implements IComparable(Of Point)

        Public Sub New(mx As Double, my As Double)
            X = mx
            Y = my
        End Sub

        Public ReadOnly Property X As Double
        Public ReadOnly Property Y As Double

        Public Function CompareTo(other As Point) As Integer Implements IComparable(Of Point).CompareTo
            Dim c = X.CompareTo(other.X)
            If c <> 0 Then
                Return c
            End If
            Return Y.CompareTo(other.Y)
        End Function

        Public Overrides Function ToString() As String
            Return String.Format("({0}, {1})", X, Y)
        End Function
    End Structure

    Structure Line
        Public Sub New(mp1 As Point, mp2 As Point, Optional segment As Boolean = False)
            If P2.CompareTo(P1) < 0 Then
                P1 = mp2
                P2 = mp1
            Else
                P1 = mp1
                P2 = mp2
            End If
            IsSegment = segment
            If P1.X = P2.X Then
                Slope = Double.PositiveInfinity
                YIntercept = Double.NaN
            Else
                Slope = (P2.Y - P1.Y) / (P2.X - P1.X)
                YIntercept = P2.Y - Slope * P2.X
            End If
        End Sub

        Public ReadOnly Property P1 As Point
        Public ReadOnly Property P2 As Point
        Public ReadOnly Property Slope As Double
        Public ReadOnly Property YIntercept As Double
        Public ReadOnly Property IsSegment As Boolean

        Public Function IsVertical() As Boolean
            Return P1.X = P2.X
        End Function

        Public Overrides Function ToString() As String
            Return String.Format("[{0}, {1}]", P1, P2)
        End Function
    End Structure

    Structure Circle
        Public Sub New(c As Point, r As Double)
            Center = c
            Radius = r
        End Sub

        Public ReadOnly Property Center As Point
        Public ReadOnly Property Radius As Double

        Public Function X() As Double
            Return Center.X
        End Function

        Public Function Y() As Double
            Return Center.Y
        End Function

        Public Overrides Function ToString() As String
            Return String.Format("{{ C:{0}, R:{1} }}", Center, Radius)
        End Function
    End Structure

    Function Intersection(oc As Circle, ol As Line) As IEnumerable(Of Point)
        Dim LineIntersection = Iterator Function(ic As Circle, il As Line) As IEnumerable(Of Point)
                                   Dim m = il.Slope
                                   Dim c = il.YIntercept
                                   Dim p = ic.X
                                   Dim q = ic.Y
                                   Dim r = ic.Radius

                                   If il.IsVertical Then
                                       Dim x = il.P1.X
                                       Dim B = -2 * q
                                       Dim CC = p * p + q * q - r * r + x * x - 2 * p * x
                                       Dim D = B * B - 4 * CC
                                       If D = 0 Then
                                           Yield New Point(x, -q)
                                       ElseIf D > 0 Then
                                           D = Math.Sqrt(D)
                                           Yield New Point(x, (-B - D) / 2)
                                           Yield New Point(x, (-B + D) / 2)
                                       End If
                                   Else
                                       Dim A = m * m + 1
                                       Dim B = 2 * (m * c - m * q - p)
                                       Dim CC = p * p + q * q - r * r + c * c - 2 * c * q
                                       Dim D = B * B - 4 * A * CC
                                       If D = 0 Then
                                           Dim x = -B / (2 * A)
                                           Dim y = m * x + c
                                           Yield New Point(x, y)
                                       ElseIf D > 0 Then
                                           D = Math.Sqrt(D)
                                           Dim x = (-B - D) / (2 * A)
                                           Dim y = m * x + c
                                           Yield New Point(x, y)
                                           x = (-B + D) / (2 * A)
                                           y = m * x + c
                                           Yield New Point(x, y)
                                       End If
                                   End If
                               End Function

        Dim int = LineIntersection(oc, ol)
        If ol.IsSegment Then
            Return int.Where(Function(p) p.CompareTo(ol.P1) >= 0 AndAlso p.CompareTo(ol.P2) <= 0)
        Else
            Return int
        End If
    End Function

    Sub Print(c As Circle, lines() As Line)
        Console.WriteLine("Circle: {0}", c)
        For Each line In lines
            Console.Write(vbTab)
            If line.IsSegment Then
                Console.Write("Segment: ")
            Else
                Console.Write("Line: ")
            End If
            Console.WriteLine(line)

            Dim points = Intersection(c, line).ToList

            Console.Write(vbTab + vbTab)
            If points.Count = 0 Then
                Console.WriteLine("do not intersect")
            Else
                Console.WriteLine("intersect at {0}", String.Join(" and ", points))
            End If
        Next
        Console.WriteLine()
    End Sub

    Sub Main()
        Dim c = New Circle(New Point(3, -5), 3)
        Dim lines() As Line = {
            New Line(New Point(-10, 11), New Point(10, -9)),
            New Line(New Point(-10, 11), New Point(-11, 12), True),
            New Line(New Point(3, -2), New Point(7, -2))
            }
        Print(c, lines)

        c = New Circle(New Point(0, 0), 4)
        lines = {
            New Line(New Point(0, -3), New Point(0, 6)),
            New Line(New Point(0, -3), New Point(0, 6), True)
            }
        Print(c, lines)

        c = New Circle(New Point(4, 2), 5)
        lines = {
            New Line(New Point(6, 3), New Point(10, 7)),
            New Line(New Point(7, 4), New Point(11, 8), True)
            }
        Print(c, lines)
    End Sub

End Module
