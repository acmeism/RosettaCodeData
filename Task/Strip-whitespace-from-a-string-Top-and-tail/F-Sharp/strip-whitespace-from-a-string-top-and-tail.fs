[<EntryPoint>]
let main args =
    printfn "%A" (args.[0].TrimStart())
    printfn "%A" (args.[0].TrimEnd())
    printfn "%A" (args.[0].Trim())
    0
