open System.Collections.Generic
let VanEck() =
    let rec _vanEck (num:int) (pos:int) (lastOccurence:Dictionary<int, int>) =
        match lastOccurence.TryGetValue num with
        | (true, position) ->
            set num pos (pos - position) lastOccurence
        | _ ->
            set num pos 0 lastOccurence
    and set num pos next lastOccurenceByNumber = seq {
            lastOccurenceByNumber.[num] <- pos
            yield next
            yield! _vanEck next (pos + 1) lastOccurenceByNumber
        }

    seq {
        yield 0
        yield! _vanEck 0 1 (new Dictionary<int, int>())
    }

VanEck() |> Seq.take 10 |> Seq.map (sprintf "%i") |> String.concat " " |> printfn "The first ten terms of the sequence : %s"
VanEck() |> Seq.skip 990 |> Seq.take 10 |> Seq.map (sprintf "%i") |> String.concat " " |> printfn "Terms 991 - to - 1000 of the sequence : %s"
