open System.Text.RegularExpressions
let splitRuns s = Regex("""(.)\1*""").Matches(s) |> Seq.cast<Match> |> Seq.map (fun m -> m.Value) |> Seq.toList
printfn "%A" (splitRuns """gHHH5YY++///\""")
