[<EntryPoint>]
let main argv =
    let fs = List.map (fun i -> fun () -> i*i) [0..9]
    do List.iter (fun f -> printfn "%d" <| f()) fs
    0
