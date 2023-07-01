open System
open System.Numerics

let deg2rad d = d * Math.PI / 180.
let rad2deg r = r * 180. / Math.PI

[<EntryPoint>]
let main argv =
    let makeComplex = fun r ->  Complex.FromPolarCoordinates(1., r)
    argv
    |> Seq.map (Double.Parse >> deg2rad >> makeComplex)
    |> Seq.fold (fun x y -> Complex.Add(x,y)) Complex.Zero
    |> fun c -> c.Phase |> rad2deg
    |> printfn "Mean angle for [%s]: %g°" (String.Join("; ",argv))
    0
