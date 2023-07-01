Imports ConvexHull

Module Module1

    Class Point : Implements IComparable(Of Point)
        Public Property X As Integer
        Public Property Y As Integer

        Public Sub New(x As Integer, y As Integer)
            Me.X = x
            Me.Y = y
        End Sub

        Public Function CompareTo(other As Point) As Integer Implements IComparable(Of Point).CompareTo
            Return X.CompareTo(other.X)
        End Function

        Public Overrides Function ToString() As String
            Return String.Format("({0}, {1})", X, Y)
        End Function
    End Class

    Function ConvexHull(p As List(Of Point)) As List(Of Point)
        If p.Count = 0 Then
            Return New List(Of Point)
        End If
        p.Sort()
        Dim h As New List(Of Point)

        ' Lower hull
        For Each pt In p
            While h.Count >= 2 AndAlso Not Ccw(h(h.Count - 2), h(h.Count - 1), pt)
                h.RemoveAt(h.Count - 1)
            End While
            h.Add(pt)
        Next

        ' Upper hull
        Dim t = h.Count + 1
        For i = p.Count - 1 To 0 Step -1
            Dim pt = p(i)
            While h.Count >= t AndAlso Not Ccw(h(h.Count - 2), h(h.Count - 1), pt)
                h.RemoveAt(h.Count - 1)
            End While
            h.Add(pt)
        Next

        h.RemoveAt(h.Count - 1)
        Return h
    End Function

    Function Ccw(a As Point, b As Point, c As Point) As Boolean
        Return ((b.X - a.X) * (c.Y - a.Y)) > ((b.Y - a.Y) * (c.X - a.X))
    End Function

    Sub Main()
        Dim points As New List(Of Point) From {
            New Point(16, 3),
            New Point(12, 17),
            New Point(0, 6),
            New Point(-4, -6),
            New Point(16, 6),
            New Point(16, -7),
            New Point(16, -3),
            New Point(17, -4),
            New Point(5, 19),
            New Point(19, -8),
            New Point(3, 16),
            New Point(12, 13),
            New Point(3, -4),
            New Point(17, 5),
            New Point(-3, 15),
            New Point(-3, -9),
            New Point(0, 11),
            New Point(-9, -3),
            New Point(-4, -2),
            New Point(12, 10)
        }

        Dim hull = ConvexHull(points)
        Dim it = hull.GetEnumerator()
        Console.Write("Convex Hull: [")
        If it.MoveNext() Then
            Console.Write(it.Current)
        End If
        While it.MoveNext()
            Console.Write(", {0}", it.Current)
        End While
        Console.WriteLine("]")
    End Sub

End Module
