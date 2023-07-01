open System

let convert seconds =
    let span = TimeSpan.FromSeconds(seconds |> float)
    let (wk, day) = Math.DivRem(span.Days, 7)
    let parts =
        [(wk, "wk"); (day, "day"); (span.Hours, "hr"); (span.Minutes, "min"); (span.Seconds, "sec")]
    let result =
        List.foldBack (fun (n, u) acc ->
                    (if n > 0 then n.ToString() + " " + u else "")
                    + (if n > 0 && acc.Length > 0 then ", " else "")
                    + acc
                  ) parts ""
    if result.Length > 0 then result else "0 sec"

[<EntryPoint>]
let main argv =
    argv
    |> Seq.map (fun str -> let sec = UInt32.Parse str in (sec, convert sec))
    |> Seq.iter (fun (s, v) -> printfn "%10i = %s" s v)
    0
