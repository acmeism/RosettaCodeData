open System

let ld x = Math.Log x / Math.Log 2.

let entropy (s : string) =
    let n = float s.Length
    Seq.groupBy id s
    |> Seq.map (fun (_, vals) -> float (Seq.length vals) / n)
    |> Seq.fold (fun e p -> e - p * ld p) 0.

printfn "%f" (entropy "1223334444")
