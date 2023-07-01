open System

let decode uri = Uri.UnescapeDataString(uri)

[<EntryPoint>]
let main argv =
    printfn "%s" (decode "http%3A%2F%2Ffoo%20bar%2F")
    0
