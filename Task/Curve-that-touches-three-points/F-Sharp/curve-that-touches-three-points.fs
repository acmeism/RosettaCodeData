// Curve that touches three points. Nigel Galloway: September 13th., 2023
open Plotly.NET
let points=let a=LIF([10;100;200],[10;200;10]).Expression in [10.0..200.0]|>List.map(fun n->(n,(Evaluate.evaluate (Map.ofList ["x",n]) a).RealValue))
Chart.Point(points)|>Chart.show
