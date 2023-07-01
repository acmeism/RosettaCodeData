open System
open System.Text.RegularExpressions

[<EntryPoint>]
let main argv =
    let rosettacodeSpecialCategoriesAddress =
        "http://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000"
    let rosettacodeProgrammingLaguagesAddress =
        "http://rosettacode.org/wiki/Category:Programming_Languages"

    let getWebContent (url :string)  =
        using (new System.Net.WebClient()) (fun x -> x.DownloadString url)

    let regexForTitleCategoryFollowedOptionallyByMembercount =
        new Regex("""
            title="Category: (?<Name> [^"]* ) ">    # capture the name of the category
            (                   # group begin for optional part
                [^(]*           # ignore up to next open paren (on this line)
                \(              # verbatim open paren
                    (?<Number>
                        \d+     # a number (= some digits)
                    )
                    \s+         # whitespace
                    member(s?)  # verbatim text members (maybe singular)
                \)              # verbatim closing paren
            )?                  # end of optional part
            """, // " <- Make syntax highlighting happy
            RegexOptions.IgnorePatternWhitespace ||| RegexOptions.ExplicitCapture)
    let matchesForTitleCategoryFollowedOptionallyByMembercount str =
        regexForTitleCategoryFollowedOptionallyByMembercount.Matches(str)

    let languages =
        matchesForTitleCategoryFollowedOptionallyByMembercount
            (getWebContent rosettacodeProgrammingLaguagesAddress)
        |> Seq.cast
        |> Seq.map (fun (m: Match) -> (m.Groups.Item("Name").Value, true))
        |> Map.ofSeq

    let entriesWithCount =
        let parse str = match Int32.TryParse(str) with | (true, n) -> n | (false, _) -> -1
        matchesForTitleCategoryFollowedOptionallyByMembercount
            (getWebContent rosettacodeSpecialCategoriesAddress)
        |> Seq.cast
        |> Seq.map (fun (m: Match) ->
            (m.Groups.Item("Name").Value, parse (m.Groups.Item("Number").Value)))
        |> Seq.filter (fun p -> (snd p) > 0 &&  Map.containsKey (fst p) languages)
        |> Seq.sortBy (fun x -> -(snd x))


    Seq.iter2 (fun i x -> printfn "%4d. %s" i x)
        (seq { 1 .. 20 })
        (entriesWithCount |> Seq.map (fun x -> sprintf "%3d - %s" (snd x) (fst x)))
    0
