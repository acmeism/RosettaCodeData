[<EntryPoint>]
let main argv =
    let fs = List.init 10 (fun i -> fun () -> i*i)
    do List.iter (fun f -> printfn "%d" <| f()) fs
    0
