let isPrefix p (s : string) = s.StartsWith(p)
let getPrefix n (s : string) = s.Substring(0,n)

let repPrefixOf str =
    let rec isRepeatedPrefix p s =
        if isPrefix p s then isRepeatedPrefix p (s.Substring (p.Length))
        else isPrefix s p

    let rec getLongestRepeatedPrefix n =
        if n = 0 then None
        elif isRepeatedPrefix (getPrefix n str) str then Some(getPrefix n str)
        else getLongestRepeatedPrefix (n-1)

    getLongestRepeatedPrefix (str.Length/2)

[<EntryPoint>]
let main argv =
    printfn "Testing for rep-string (and showing the longest repeated prefix in case):"
    [
    "1001110011"
    "1110111011"
    "0010010010"
    "1010101010"
    "1111111111"
    "0100101101"
    "0100100"
    "101"
    "11"
    "00"
    "1"
    ] |>
    List.map (fun s ->
        match repPrefixOf s with | None -> s + ": NO" | Some(p) -> s + ": YES ("+ p + ")")
    |> List.iter (printfn "%s")
    0
