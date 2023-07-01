Sub draw()
    Dim sh As Shape, sl As Shape
    Set sh = ActiveDocument.Shapes.AddCanvas(100, 100, 320, 240)
    Set sl = sh.CanvasItems.AddLine(100, 100, 101, 100)
    sl.Line.ForeColor.RGB = RGB(Red:=255, Green:=0, Blue:=0)
End Sub
