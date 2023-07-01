let closest_pairs (xys: Point []) =
  let n = xys.Length
  seq { for i in 0..n-2 do
          for j in i+1..n-1 do
            yield xys.[i], xys.[j] }
  |> Seq.minBy (fun (p0, p1) -> (p1 - p0).LengthSquared)
