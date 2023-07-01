Sub pentagram()
    With ActiveSheet.Shapes.AddShape(msoShape5pointStar, 10, 10, 400, 400)
        .Fill.ForeColor.RGB = RGB(255, 0, 0)
        .Line.Weight = 3
        .Line.ForeColor.RGB = RGB(0, 0, 255)
    End With
End Sub
