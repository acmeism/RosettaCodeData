// ISBN13 Check Digit
open System

let parseInput (input: string) =
    Seq.map(fun c -> c |> string) input |> Seq.toList |> List.map(fun x -> Int32.Parse x)

[<EntryPoint>]
let main argv =
    let isbnnum = parseInput (String.filter (fun x -> x <> '-') argv.[0])
    // Multiply every other digit by 3
    let everyOther = List.mapi (fun i x -> if i % 2 = 0 then x * 3 else x) isbnnum
    // Sum the *3 list with the original list
    let sum = List.sum everyOther + List.sum isbnnum
    // If the remainder of sum / 10 is 0 then it's a valid ISBN13
    if sum % 10 = 0 then
        printfn "%s Valid ISBN13" argv.[0]
    else
        printfn "%s Invalid ISBN13" argv.[0]
    0
