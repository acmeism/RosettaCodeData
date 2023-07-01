open System

let Repeat c f =
    for _ in 1 .. c do
        f()

let Hello _ =
    printfn "Hello world"

[<EntryPoint>]
let main _ =
    Repeat 3 Hello

    0 // return an integer exit code
