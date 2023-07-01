open System.Windows
open System.Windows.Media

let m = Matrix(0.0, 0.5, -0.5, 0.0, 0.0, 0.0)

let step segs =
  seq { for a: Point, b: Point in segs do
          let x = a + 0.5 * (b - a) + (b - a) * m
          yield! [a, x; b, x] }

let rec nest n f x =
  if n=0 then x else nest (n-1) f (f x)

[<System.STAThread>]
do
  let path = Shapes.Path(Stroke=Brushes.Black, StrokeThickness=0.001)
  path.Data <-
    PathGeometry
      [ for a, b in nest 13 step (seq [Point(0.0, 0.0), Point(1.0, 0.0)]) ->
          PathFigure(a, [(LineSegment(b, true) :> PathSegment)], false) ]
  (Application()).Run(Window(Content=Controls.Viewbox(Child=path))) |> ignore
