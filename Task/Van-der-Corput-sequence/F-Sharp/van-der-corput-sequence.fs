open System

let vdc n b =
    let rec loop n denom acc =
        if n > 0l then
            let m, remainder = Math.DivRem(n, b)
            loop m (denom * b) (acc + (float remainder) / (float (denom * b)))
        else acc
    loop n 1 0.0


[<EntryPoint>]
let main argv =
    printfn "%A" [ for n in 0 .. 9 -> (vdc n 2) ]
    printfn "%A" [ for n in 0 .. 9 -> (vdc n 5) ]
    0
