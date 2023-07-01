[<EntryPoint>]
let main (args : string[]) =
    let k = int(args.[0])

    let l x = fun() -> x

    let rec a k x1 x2 x3 x4 x5 =
        if k <= 0 then
            x4() + x5()
        else
            let k = ref k
            let rec b() =
                k := !k - 1
                a !k b x1 x2 x3 x4
            b()

    a k (l 1) (l -1) (l -1) (l 1) (l 0)
    |> printfn "%A"

    0
