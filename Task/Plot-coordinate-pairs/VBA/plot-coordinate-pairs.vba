Private Sub plot_coordinate_pairs(x As Variant, y As Variant)
    Dim chrt As Chart
    Set chrt = ActiveSheet.Shapes.AddChart.Chart
    With chrt
        .ChartType = xlLine
        .HasLegend = False
        .HasTitle = True
        .ChartTitle.Text = "Time"
        .SeriesCollection.NewSeries
        .SeriesCollection.Item(1).XValues = x
        .SeriesCollection.Item(1).Values = y
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "microseconds"
    End With
End Sub
Public Sub main()
    x = [{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}]
    y = [{2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0}]
    plot_coordinate_pairs x, y
End Sub
