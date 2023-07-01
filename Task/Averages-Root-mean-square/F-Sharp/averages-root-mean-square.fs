let RMS (x:float list) : float = List.map (fun y -> y**2.0) x |> List.average |> System.Math.Sqrt

let res = RMS [1.0..10.0]
