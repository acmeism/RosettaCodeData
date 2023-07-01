open System

[<EntryPoint>]
let main args =
    printfn "%A" (Environment.GetEnvironmentVariable("PATH"))
    0
