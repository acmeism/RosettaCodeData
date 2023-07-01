Imports System.Math

Module RayCasting

    Private square As Integer()() = {New Integer() {0, 0}, New Integer() {20, 0}, New Integer() {20, 20}, New Integer() {0, 20}}
    Private squareHole As Integer()() = {New Integer() {0, 0}, New Integer() {20, 0}, New Integer() {20, 20}, New Integer() {0, 20}, New Integer() {5, 5}, New Integer() {15, 5}, New Integer() {15, 15}, New Integer() {5, 15}}
    Private strange As Integer()() = {New Integer() {0, 0}, New Integer() {5, 5}, New Integer() {0, 20}, New Integer() {5, 15}, New Integer() {15, 15}, New Integer() {20, 20}, New Integer() {20, 0}}
    Private hexagon As Integer()() = {New Integer() {6, 0}, New Integer() {14, 0}, New Integer() {20, 10}, New Integer() {14, 20}, New Integer() {6, 20}, New Integer() {0, 10}}
    Private shapes As Integer()()() = {square, squareHole, strange, hexagon}

    Public Sub Main()
        Dim testPoints As Double()() = {New Double() {10, 10}, New Double() {10, 16}, New Double() {-20, 10}, New Double() {0, 10}, New Double() {20, 10}, New Double() {16, 10}, New Double() {20, 20}}

        For Each shape As Integer()() In shapes
            For Each point As Double() In testPoints
                Console.Write(String.Format("{0} ", Contains(shape, point).ToString.PadLeft(7)))
            Next
            Console.WriteLine()
        Next
    End Sub

    Private Function Contains(shape As Integer()(), point As Double()) As Boolean

        Dim inside As Boolean = False
        Dim length As Integer = shape.Length

        For i As Integer = 0 To length - 1
            If Intersects(shape(i), shape((i + 1) Mod length), point) Then
                inside = Not inside
            End If
        Next

        Return inside
    End Function

    Private Function Intersects(a As Integer(), b As Integer(), p As Double()) As Boolean

        If a(1) > b(1) Then Return Intersects(b, a, p)
        If p(1) = a(1) Or p(1) = b(1) Then p(1) += 0.0001
        If p(1) > b(1) Or p(1) < a(1) Or p(0) >= Max(a(0), b(0)) Then Return False
        If p(0) < Min(a(0), b(0)) Then Return True
        Dim red As Double = (p(1) - a(1)) / (p(0) - a(0))
        Dim blue As Double = (b(1) - a(1)) / (b(0) - a(0))

        Return red >= blue
    End Function
End Module
