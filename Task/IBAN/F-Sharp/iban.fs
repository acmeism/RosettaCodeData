open System
open System.Text.RegularExpressions

// A little utility to thread a negative test result (Option.None) through a
// pipeline of tests
let inline (|~>) valOption proc =
    match valOption with
    | Some(value) -> proc value
    | None -> None

[<EntryPoint>]
let main argv =
    let iban = if argv.Length = 0 then "" else argv.[0]
    iban
    |> (fun iban ->     // Check for illegal characters
            if Regex.IsMatch(iban, @"[^0-9A-Za-z ]") then None else Some(iban.ToUpper().Replace(" ", "")))
    |~> (fun iban ->    // Check length per country code
            let lengthPerCountry =
                dict [
                    ("AL", 28); ("AD", 24); ("AT", 20); ("AZ", 28); ("BE", 16); ("BH", 22); ("BA", 20); ("BR", 29);
                    ("BG", 22); ("CR", 21); ("HR", 21); ("CY", 28); ("CZ", 24); ("DK", 18); ("DO", 28); ("EE", 20);
                    ("FO", 18); ("FI", 18); ("FR", 27); ("GE", 22); ("DE", 22); ("GI", 23); ("GR", 27); ("GL", 18);
                    ("GT", 28); ("HU", 28); ("IS", 26); ("IE", 22); ("IL", 23); ("IT", 27); ("KZ", 20); ("KW", 30);
                    ("LV", 21); ("LB", 28); ("LI", 21); ("LT", 20); ("LU", 20); ("MK", 19); ("MT", 31); ("MR", 27);
                    ("MU", 30); ("MC", 27); ("MD", 24); ("ME", 22); ("NL", 18); ("NO", 15); ("PK", 24); ("PS", 29);
                    ("PL", 28); ("PT", 25); ("RO", 24); ("SM", 27); ("SA", 24); ("RS", 22); ("SK", 24); ("SI", 19);
                    ("ES", 24); ("SE", 24); ("CH", 21); ("TN", 24); ("TR", 26); ("AE", 23); ("GB", 22); ("VG", 24);
                ]
            let country = iban.Substring(0, Math.Min(2, iban.Length))
            match lengthPerCountry.TryGetValue(country) with
            | true, length ->   // country should have iban of this length
                if length = iban.Length then Some(iban) else None
            | _ -> None     // country not known
        )
    |~> (fun iban -> Some(iban.Substring(4) + iban.Substring(0,4)))
    |~> (fun iban ->
            let replaceBase36LetterWithBase10String (s : string) (c :char) = s.Replace(c.ToString(), ((int)c - (int)'A' + 10).ToString())
            Some(List.fold replaceBase36LetterWithBase10String iban [ 'A' .. 'Z' ]))
    |~> (fun iban ->    // iban mod 97
            // We could have used BigInteger, but with a loop by 7 char each
            // over the long digit string we get away with Int32 arithmetic
            // (as described in the Wikipedia article)
            let reduceOnce r n = Int32.Parse(r.ToString() + n) % 97
            let rest =
                Regex.Matches(iban.Substring(2), @"\d{1,7}") |> Seq.cast |> Seq.map (fun x -> x.ToString())
                |> Seq.fold reduceOnce (reduceOnce 0 (iban.Substring(0,2)))
            // an iban needs a rest of 1
            if rest = 1 then Some(1) else None
        )
    |> function | Some(_) -> "a valid IBAN" | None -> "an invalid IBAN"
    |> printfn "%s is %s" iban
    0
