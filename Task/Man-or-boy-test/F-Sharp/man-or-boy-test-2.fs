type Tramp<'t> =
    | Delay of (unit -> Tramp<'t>)
    | Bind of Tramp<'t> * ('t -> Tramp<'t>)
    | Return of 't
    | ReturnFrom of Tramp<'t>

type Tramp() =
    member this.Delay(f) = Delay f
    member this.Bind(x, f) = Bind(x, f)
    member this.Return(x) = Return x
    member this.ReturnFrom(x) = ReturnFrom x

let tramp = Tramp()

let run (tr : Tramp<'t>) =
    let rec loop tr stack =
        match tr with
        | Delay f -> loop (f()) stack
        | Bind(x, f) -> loop x (f :: stack)
        | Return x ->
            match stack with
            | [] -> x
            | f :: stack' -> loop (f x) stack'
        | ReturnFrom tr -> loop tr stack
    loop tr []

[<EntryPoint>]
let main (args : string[]) =
    let k = int(args.[0])

    let l x = fun() -> Return x

    tramp {
        let rec a k x1 x2 x3 x4 x5 =
            tramp {
                if k <= 0 then
                    let! x4' = x4()
                    let! x5' = x5()
                    return x4' + x5'
                else
                    let k = ref k
                    let rec b() =
                        tramp {
                            k := !k - 1
                            return! a !k b x1 x2 x3 x4
                        }
                    return! b()
            }

        return! a k (l 1) (l -1) (l -1) (l 1) (l 0)
    }
    |> run
    |> printfn "%A"

    0
