Private Sub plot_coordinate_pairs(x As Variant, y As Variant)
    Dim chrt As Chart
    Set chrt = ActiveSheet.Shapes.AddChart.Chart
    With chrt
        .ChartType = xlXYScatter
        .HasLegend = False
        .SeriesCollection.NewSeries
        .SeriesCollection.Item(1).XValues = x
        .SeriesCollection.Item(1).Values = y
    End With
End Sub
Public Sub barnsley_fern()
    Const MAX = 50000
    Dim x(MAX) As Double
    Dim y(MAX) As Double
    x(0) = 0: y(0) = 0
    For i = 1 To MAX
        Select Case CInt(100 * Rnd)
            Case 0 To 1
                x(i) = 0
                y(i) = 0.16 * y(i - 1)
            Case 2 To 85
                x(i) = 0.85 * x(i - 1) + 0.04 * y(i - 1)
                y(i) = -0.04 * x(i - 1) + 0.85 * y(i - 1) + 1.6
            Case 86 To 92
                x(i) = 0.2 * x(i - 1) - 0.26 * y(i - 1)
                y(i) = 0.23 * x(i - 1) + 0.22 * y(i - 1) + 1.6
            Case 93 To 100
                x(i) = -0.15 * x(i - 1) + 0.28 * y(i - 1)
                y(i) = 0.26 * x(i - 1) + 0.24 * y(i - 1) + 0.44
        End Select
    Next i
    plot_coordinate_pairs x, y
End Sub
