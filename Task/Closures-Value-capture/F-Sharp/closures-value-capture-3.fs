[<EntryPoint>]
let main argv =
    let fs = List.mapi (fun i x -> fun () -> i*i) (List.replicate 10 None)
    do List.iter (fun f -> printfn "%d" <| f()) fs
    0
