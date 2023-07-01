#r @"C:\Program Files\FlyingFrog\FSharpForVisualization.dll"

let x = Seq.map float [|0; 1; 2; 3; 4; 5; 6; 7; 8; 9|]
let y = [|2.7; 2.8; 31.4; 38.1; 58.0; 76.2; 100.5; 130.0; 149.3; 180.0|]

open FlyingFrog.Graphics

Plot([Data(Seq.zip x y)], (0.0, 9.0))
