open System
open System.Text.RegularExpressions

(*
    .NET regexes have unlimited look-behind, so we can look for separators
    which are preceeded by an even number of (or no) escape characters
*)
let split esc sep s =
    Regex.Split (
        s,
        String.Format("(?<=(?:\b|[^{0}])(?:{0}{0})*){1}", Regex.Escape(esc), Regex.Escape(sep))
        )

let unescape esc s =
    Regex.Replace(
        s,
        Regex.Escape(esc) + "(.)",
        "$1"
        )

[<EntryPoint>]
let main argv =
    let (esc, sep) = ("^", "|")
    "one^|uno||three^^^^|four^^^|^cuatro|"
    |> split esc sep
    |> Seq.map (unescape esc)
    |> Seq.iter (fun s -> printfn "'%s'" s)
    0
