open System.IO

[<EntryPoint>]
let main argv =
    File.ReadLines(argv.[0]) |> Seq.iter (printfn "%s")
    0
