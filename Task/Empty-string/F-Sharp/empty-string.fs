open System

[<EntryPoint>]
let main args =
    let emptyString = String.Empty  // or any of the literals "" @"" """"""
    printfn "Is empty %A: %A" emptyString (emptyString = String.Empty)
    printfn "Is not empty %A: %A" emptyString (emptyString <> String.Empty)
    0
