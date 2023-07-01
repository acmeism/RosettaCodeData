[<EntryPoint>]
let main argv =
    let fs = Seq.initInfinite (fun i -> fun () -> i*i)
    do Seq.iter (fun f -> printfn "%d" <| f()) (Seq.take 10 fs)
    0
