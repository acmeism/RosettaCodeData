let dot (ax, ay, az) (bx, by, bz) =
    ax * bx + ay * by + az * bz

let cross (ax, ay, az) (bx, by, bz) =
    (ay*bz - az*by, az*bx - ax*bz, ax*by - ay*bx)

let scalTrip a b c =
    dot a (cross b c)

let vecTrip a b c =
    cross a (cross b c)

[<EntryPoint>]
let main _ =
    let a = (3.0, 4.0, 5.0)
    let b = (4.0, 3.0, 5.0)
    let c = (-5.0, -12.0, -13.0)
    printfn "%A" (dot a b)
    printfn "%A" (cross a b)
    printfn "%A" (scalTrip a b c)
    printfn "%A" (vecTrip a b c)
    0 // return an integer exit code
