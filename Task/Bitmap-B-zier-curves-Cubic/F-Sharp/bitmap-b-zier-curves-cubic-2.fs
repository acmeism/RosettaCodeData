// For rendering..
let drawPoints points (canvas:System.Windows.Controls.Canvas) =
    let addLineToScreen (v1:vector) (v2:vector) =
        canvas.Children.Add(new System.Windows.Shapes.Line(X1 = v1.[0],
                                        Y1 = -v1.[1],
                                        X2 = v2.[0],
                                        Y2 = -v2.[1],
                                        StrokeThickness = 2.)) |> ignore
    let renderPoint (previous:vector) (current:vector) =
        addLineToScreen previous current
        current

    points |> List.fold renderPoint points.Head
