#light
let sum_series (max : float) =
    let rec f (a:float, x : float) =
        match x with
            | 0. -> a
            | x -> f ((1. / (x * x) + a), x - 1.)
    f (0., max)

[<EntryPoint>]
let main args =
    let (b, max) = System.Double.TryParse(args.[0])
    printfn "%A" (sum_series max)
    0
