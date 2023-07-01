open System

let add (ax, ay) (bx, by) =
    (ax+bx, ay+by)

let sub (ax, ay) (bx, by) =
    (ax-bx, ay-by)

let mul (ax, ay) c =
    (ax*c, ay*c)

let div (ax, ay) c =
    (ax/c, ay/c)

[<EntryPoint>]
let main _ =
    let a = (5.0, 7.0)
    let b = (2.0, 3.0)

    printfn "%A" (add a b)
    printfn "%A" (sub a b)
    printfn "%A" (mul a 11.0)
    printfn "%A" (div a 2.0)
    0 // return an integer exit code
