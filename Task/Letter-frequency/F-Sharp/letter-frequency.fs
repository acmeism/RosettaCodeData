let alphabet =
    ['A'..'Z'] |> Set.ofList

let letterFreq (text : string) =
    text.ToUpper().ToCharArray()
    |> Array.filter (fun x -> alphabet.Contains(x))
    |> Seq.countBy (fun x -> x)
    |> Seq.sort

let v = "Now is the time for all good men to come to the aid of the party"

let res = letterFreq v

for (letter, freq) in res do
    printfn "%A, %A" letter freq
