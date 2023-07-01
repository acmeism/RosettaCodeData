open System
let Inputs = ["710889"; "B0YBKJ"; "406566"; "B0YBLH"; "228276"; "B0YBKL"
              "557910"; "B0YBKR"; "585284"; "B0YBKT"; "B00030"]

let Vowels = set ['A'; 'E'; 'I'; 'O'; 'U']
let Weights = [1; 3; 1; 7; 3; 9; 1]

let inline isVowel c = Vowels.Contains (Char.ToUpper c)

let char2value c =
    if Char.IsDigit c then int c - 0x30
    else (['A'..'Z'] |> List.findIndex ((=) (Char.ToUpper c))) + 10

let sedolCheckDigit (input: string) =
    if input.Length <> 6 || input |> Seq.exists isVowel then
        failwithf "Input must be six characters long and not contain vowels: %s" input

    let sum = Seq.map2 (fun ch weight -> (char2value ch) * weight) input Weights |> Seq.sum
    (10 - sum%10)%10

let addCheckDigit inputs =
    inputs |> List.map (fun s -> s + (sedolCheckDigit s).ToString())

let processDigits() =
    try
        addCheckDigit Inputs |> List.iter (printfn "%s")
    with
        ex -> printfn "ERROR: %s" ex.Message
