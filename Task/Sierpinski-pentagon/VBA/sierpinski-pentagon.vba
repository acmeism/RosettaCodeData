Private Sub sierpinski(Order_ As Integer, Side As Double)
    Dim Circumradius As Double, Inradius As Double
    Dim Height As Double, Diagonal As Double, HeightDiagonal As Double
    Dim Pi As Double, p(5) As String, Shp As Shape
    Circumradius = Sqr(50 + 10 * Sqr(5)) / 10
    Inradius = Sqr(25 + 10 * Sqr(5)) / 10
    Height = Circumradius + Inradius
    Diagonal = (1 + Sqr(5)) / 2
    HeightDiagonal = Sqr(10 + 2 * Sqr(5)) / 4
    Pi = WorksheetFunction.Pi
    Ratio = Height / (2 * Height + HeightDiagonal)
    'Get a base figure
    Set Shp = ThisWorkbook.Worksheets(1).Shapes.AddShape(msoShapeRegularPentagon, _
        2 * Side, 3 * Side / 2 + (Circumradius - Inradius) * Side, Diagonal * Side, Height * Side)
    p(0) = Shp.Name
    Shp.Rotation = 180
    Shp.Line.Weight = 0
    For j = 1 To Order_
        'Place 5 copies of the figure in a circle around it
        For i = 0 To 4
            'Copy the figure
            Set Shp = Shp.Duplicate
            p(i + 1) = Shp.Name
            If i = 0 Then Shp.Rotation = 0
            'Place around in a circle
            Shp.Left = 2 * Side + Side * Inradius * 2 * Cos(2 * Pi * (i - 1 / 4) / 5)
            Shp.Top = 3 * Side / 2 + Side * Inradius * 2 * Sin(2 * Pi * (i - 1 / 4) / 5)
            Shp.Visible = msoTrue
        Next i
        'Group the 5 figures
        Set Shp = ThisWorkbook.Worksheets(1).Shapes.Range(p()).Group
        p(0) = Shp.Name
        If j < Order_ Then
            'Shrink the figure
            Shp.ScaleHeight Ratio, False
            Shp.ScaleWidth Ratio, False
            'Flip vertical and place in the center
            Shp.Rotation = 180
            Shp.Left = 2 * Side
            Shp.Top = 3 * Side / 2 + (Circumradius - Inradius) * Side
        End If
    Next j
End Sub

Public Sub main()
    sierpinski Order_:=5, Side:=200
End Sub
