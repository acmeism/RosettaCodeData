Option Strict On

Imports Point = System.Tuple(Of Double, Double)

Module Module1

    Function ShoelaceArea(v As List(Of Point)) As Double
        Dim n = v.Count
        Dim a = 0.0
        For i = 0 To n - 2
            a += v(i).Item1 * v(i + 1).Item2 - v(i + 1).Item1 * v(i).Item2
        Next
        Return Math.Abs(a + v(n - 1).Item1 * v(0).Item2 - v(0).Item1 * v(n - 1).Item2) / 2.0
    End Function

    Sub Main()
        Dim v As New List(Of Point) From {
            New Point(3, 4),
            New Point(5, 11),
            New Point(12, 8),
            New Point(9, 5),
            New Point(5, 6)
        }
        Dim area = ShoelaceArea(v)
        Console.WriteLine("Given a polygon with vertices [{0}],", String.Join(", ", v))
        Console.WriteLine("its area is {0}.", area)
    End Sub

End Module
