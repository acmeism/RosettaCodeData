let divides d n =
    match bigint.DivRem(n, d) with
    | (_, rest) -> rest = 0I

let splitToInt (str:string) = List.init str.Length (fun i -> ((int str.[i]) - (int "0".[0])))

let harshads =
    let rec loop n = seq {
        let sum = List.fold (+) 0 (splitToInt (n.ToString()))
        if divides (bigint sum) n then yield n
        yield! loop (n + 1I)
    }
    loop 1I

[<EntryPoint>]
let main argv =
    for h in (Seq.take 20 harshads) do printf "%A " h
    printfn ""
    printfn "%A" (Seq.find (fun n -> n > 1000I) harshads)
    0
