Imports System.Text

Module Module1

    Sub Swap(Of T)(ByRef a As T, ByRef b As T)
        Dim c = a
        a = b
        b = c
    End Sub

    Structure Point
        Dim x As Integer
        Dim y As Integer

        'rotate/flip a quadrant appropriately
        Sub Rot(n As Integer, rx As Boolean, ry As Boolean)
            If Not ry Then
                If rx Then
                    x = (n - 1) - x
                    y = (n - 1) - y
                End If
                Swap(x, y)
            End If
        End Sub

        Public Overrides Function ToString() As String
            Return String.Format("({0}, {1})", x, y)
        End Function
    End Structure

    Function FromD(n As Integer, d As Integer) As Point
        Dim p As Point
        Dim rx As Boolean
        Dim ry As Boolean
        Dim t = d
        Dim s = 1
        While s < n
            rx = ((t And 2) <> 0)
            ry = (((t Xor If(rx, 1, 0)) And 1) <> 0)
            p.Rot(s, rx, ry)
            p.x += If(rx, s, 0)
            p.y += If(ry, s, 0)
            t >>= 2

            s <<= 1
        End While
        Return p
    End Function

    Function GetPointsForCurve(n As Integer) As List(Of Point)
        Dim points As New List(Of Point)
        Dim d = 0
        While d < n * n
            points.Add(FromD(n, d))
            d += 1
        End While
        Return points
    End Function

    Function DrawCurve(points As List(Of Point), n As Integer) As List(Of String)
        Dim canvas(n, n * 3 - 2) As Char
        For i = 1 To canvas.GetLength(0)
            For j = 1 To canvas.GetLength(1)
                canvas(i - 1, j - 1) = " "
            Next
        Next

        For i = 1 To points.Count - 1
            Dim lastPoint = points(i - 1)
            Dim curPoint = points(i)
            Dim deltaX = curPoint.x - lastPoint.x
            Dim deltaY = curPoint.y - lastPoint.y
            If deltaX = 0 Then
                'vertical line
                Dim row = Math.Max(curPoint.y, lastPoint.y)
                Dim col = curPoint.x * 3
                canvas(row, col) = "|"
            Else
                'horizontal line
                Dim row = curPoint.y
                Dim col = Math.Min(curPoint.x, lastPoint.x) * 3 + 1
                canvas(row, col) = "_"
                canvas(row, col + 1) = "_"
            End If
        Next

        Dim lines As New List(Of String)
        For i = 1 To canvas.GetLength(0)
            Dim sb As New StringBuilder
            For j = 1 To canvas.GetLength(1)
                sb.Append(canvas(i - 1, j - 1))
            Next
            lines.Add(sb.ToString())
        Next
        Return lines
    End Function

    Sub Main()
        For order = 1 To 5
            Dim n = 1 << order
            Dim points = GetPointsForCurve(n)
            Console.WriteLine("Hilbert curve, order={0}", order)
            Dim lines = DrawCurve(points, n)
            For Each line In lines
                Console.WriteLine(line)
            Next
            Console.WriteLine()
        Next
    End Sub

End Module
