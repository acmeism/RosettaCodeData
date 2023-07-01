let fizzbuzz n =
    match n%3 = 0, n%5 = 0 with
    | true, false -> "fizz"
    | false, true -> "buzz"
    | true, true  -> "fizzbuzz"
    | _ -> string n

let printFizzbuzz() =
    [1..100] |> List.iter (fizzbuzz >> printfn "%s")
