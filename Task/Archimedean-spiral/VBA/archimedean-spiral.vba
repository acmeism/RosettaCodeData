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
Public Sub main()
    Dim x(1000) As Single, y(1000) As Single
    a = 1
    b = 9
    For i = 0 To 1000
        theta = i * WorksheetFunction.Pi() / 60
        r = a + b * theta
        x(i) = r * Cos(theta)
        y(i) = r * Sin(theta)
    Next i
    plot_coordinate_pairs x, y
End Sub
