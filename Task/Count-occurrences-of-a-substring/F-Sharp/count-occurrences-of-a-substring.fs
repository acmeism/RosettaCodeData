open System

let countSubstring (where :string) (what : string) =
    match what with
    | "" -> 0 // just a definition; infinity is not an int
    | _ -> (where.Length - where.Replace(what, @"").Length) / what.Length


[<EntryPoint>]
let main argv =
    let show where what =
        printfn @"countSubstring(""%s"", ""%s"") = %d" where what (countSubstring where what)
    show "the three truths" "th"
    show "ababababab" "abab"
    show "abc" ""
    0
