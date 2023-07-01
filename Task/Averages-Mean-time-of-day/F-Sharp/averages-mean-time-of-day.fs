open System
open System.Numerics

let deg2rad d = d * Math.PI / 180.
let rad2deg r = r * 180. / Math.PI
let makeComplex = fun r ->  Complex.FromPolarCoordinates(1., r)
// 1 msec = 10000 ticks
let time2deg = TimeSpan.Parse >> (fun ts -> ts.Ticks) >> (float) >> (*) (10e-9/24.)
let deg2time = (*) (24. * 10e7) >> (int64) >> TimeSpan

[<EntryPoint>]
let main argv =
    let msg = "Average time for [" + (String.Join("; ",argv)) + "] is"
    argv
    |> Seq.map (time2deg >> deg2rad >> makeComplex)
    |> Seq.fold (fun x y -> Complex.Add(x,y)) Complex.Zero
    |> fun c -> c.Phase |> rad2deg
    |> fun d -> if d < 0. then d + 360. else d
    |> deg2time |> fun t -> t.ToString(@"hh\:mm\:ss")
    |> printfn "%s: %s" msg
    0
