open System

[<EntryPoint>]
let main args =
    printfn "%s" (Uri.EscapeDataString(args.[0]))
    0
