open System;

let keyIsSortedWord = Seq.sort >> Seq.toArray >> String
let isDeranged = Seq.forall2 (<>)

let rec pairs acc l = function
| [] -> acc
| x::rtail ->
    pairs (acc @ List.fold (fun acc y -> (y, x)::acc) [] l) (x::l) rtail


[<EntryPoint>]
let main args =
    System.IO.File.ReadAllLines("unixdict.txt")
    |> Seq.groupBy keyIsSortedWord
    |> Seq.fold (fun (len, found) (key, words) ->
        if String.length key < len || Seq.length words < 2 then (len, found)
        else
            let d = List.filter (fun (a, b) -> isDeranged a b) (pairs [] [] (List.ofSeq words))
            if List.length d = 0 then (len, found)
            elif String.length key = len then (len, found @ d)
            else (String.length key, d)
    ) (0, [])
    |> snd
    |> printfn "%A"
    0
