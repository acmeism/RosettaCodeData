let rec spell_word_with blocks w =
    let rec look_for_right_candidate candidates noCandidates c rest =
        match candidates with
        | [] -> false
        | c0::cc ->
            if spell_word_with (cc@noCandidates) rest then true
            else look_for_right_candidate cc (c0::noCandidates) c rest

    match w with
    | "" -> true
    | w ->
        let c = w.[0]
        let rest = w.Substring(1)
        let (candidates, noCandidates) = List.partition(fun (c1,c2) -> c = c1 || c = c2) blocks
        look_for_right_candidate candidates noCandidates c rest

[<EntryPoint>]
let main argv =
    let default_blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"
    let blocks =
        (if argv.Length > 0 then argv.[0] else default_blocks).Split()
        |> List.ofArray
        |> List.map(fun s -> s.ToUpper())
        |> List.map(fun s2 -> s2.[0], s2.[1])
    let words =
        (if argv.Length > 0 then List.ofArray(argv).Tail else [])
        |> List.map(fun s -> s.ToUpper())

    List.iter (fun w -> printfn "Using the blocks we can make the word '%s': %b" w (spell_word_with blocks w)) words
    0
