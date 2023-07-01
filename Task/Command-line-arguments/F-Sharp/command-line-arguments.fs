#light
[<EntryPoint>]
let main args =
    Array.iter (fun x -> printfn "%s" x) args
    0
