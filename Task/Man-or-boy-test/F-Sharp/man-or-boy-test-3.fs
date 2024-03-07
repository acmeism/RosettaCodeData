[<EntryPoint>]
let main (args : string[]) =
    let k = int(args.[0])

    let l x cont = cont x

    let rec a k x1 x2 x3 x4 x5 cont =
        if k <= 0 then
            x4 (fun n4 -> x5 (fun n5 -> cont (n4+n5)))
        else
            let mutable k = k
            let rec b cont =
                k <- k - 1
                a k b x1 x2 x3 x4 cont
            b cont

    a k (l 1) (l -1) (l -1) (l 1) (l 0) (printfn "%d")

    0
