Private Sub yinyang(Top As Integer, Left As Integer, Size As Integer)
    ActiveSheet.Shapes.AddShape(msoShapeChord, Top, Left, Size, Size).Select
    With Selection.ShapeRange
        .Adjustments.Item(1) = 90
        .Fill.ForeColor.RGB = RGB(255, 255, 255)
        .Line.ForeColor.RGB = RGB(0, 0, 0)
    End With
    ActiveSheet.Shapes.AddShape(msoShapeChord, Top, Left, Size, Size).Select
    With Selection.ShapeRange
        .Adjustments.Item(1) = 90
        .IncrementRotation 180
        .Fill.ForeColor.RGB = RGB(0, 0, 0)
        .Line.ForeColor.RGB = RGB(0, 0, 0)
    End With
    ActiveSheet.Shapes.AddShape(msoShapeOval, Top + Size \ 4, Left, Size \ 2, Size \ 2).Select
    With Selection.ShapeRange
        .Fill.ForeColor.RGB = RGB(255, 255, 255)
        .Line.ForeColor.RGB = RGB(255, 255, 255)
    End With
    ActiveSheet.Shapes.AddShape(msoShapeOval, Top + Size \ 4, Left + Size \ 2, Size \ 2, Size \ 2).Select
    With Selection.ShapeRange
        .Fill.ForeColor.RGB = RGB(0, 0, 0)
        .Line.ForeColor.RGB = RGB(0, 0, 0)
    End With
    ActiveSheet.Shapes.AddShape(msoShapeOval, Top + 5 * Size \ 12, Left + Size \ 6, Size \ 6, Size \ 6).Select
    With Selection.ShapeRange
        .Fill.ForeColor.RGB = RGB(0, 0, 0)
        .Line.ForeColor.RGB = RGB(0, 0, 0)
    End With
    ActiveSheet.Shapes.AddShape(msoShapeOval, Top + 5 * Size \ 12, Left + 2 * Size \ 3, Size \ 6, Size \ 6).Select
    With Selection.ShapeRange
        .Fill.ForeColor.RGB = RGB(255, 255, 255)
        .Line.ForeColor.RGB = RGB(255, 255, 255)
    End With
    ActiveSheet.Shapes.SelectAll
    Selection.ShapeRange.Group
End Sub
Public Sub draw()
    yinyang 200, 100, 100
    yinyang 275, 175, 25
End Sub
