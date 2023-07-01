open System
open System.Text.RegularExpressions

[<EntryPoint>]
let main argv =
    let langs = [| "foo"; "foo 2"; "bar"; "baz" |];    // An array of (pseudo) languages we handle
    let regexStringAlternationOfLanguageNames = String.Join("|", (Array.map Regex.Escape langs))
    let regexForOldLangSyntax =
        new Regex(String.Format("""
            <                   # Opening of a tag.
            (                   # Group alternation of 2 cases
                (                   # Group for alternation of 2 cases with a language name
                    (?<CloseMarker>/)   # Might be a closing tag,
                    |                   # Or
                    code\s              # an old <code ...> tag
                )?                  # End of alternation; optional
                \b(?<Lang>{0})\b    # Followed by the captured Language alternation
            |                   # Or
                (?<CloseMarker>/code)# An old </code> end tag
            )                   # End of group
            >                   # The final tag closing
            """, regexStringAlternationOfLanguageNames),
            RegexOptions.IgnorePatternWhitespace ||| RegexOptions.ExplicitCapture)

    let replaceEvaluator (m : Match) =
        if m.Groups.Item("CloseMarker").Length > 0 then "</" + "lang>"
        else "<lang " + m.Groups.Item("Lang").Value + ">"

    printfn "%s" (regexForOldLangSyntax.Replace(Console.In.ReadToEnd(), replaceEvaluator))
    0
