open System

let (|SeqNode|SeqEmpty|) s =
    if Seq.isEmpty s then SeqEmpty
    else SeqNode ((Seq.head s), Seq.skip 1 s)

[<EntryPoint>]
let main args =
    let splitBySeparator (str : string) = Seq.ofArray (str.Split('/'))

    let rec common2 acc = function
        | SeqEmpty -> Seq.ofList (List.rev acc)
        | SeqNode((p1, p2), rest) ->
            if p1 = p2 then common2 (p1::acc) rest
            else Seq.ofList (List.rev acc)

    let commonPrefix paths =
        match Array.length(paths) with
        | 0 -> [||]
        | 1 -> Seq.toArray (splitBySeparator paths.[0])
        | _ ->
            let argseq = Seq.ofArray paths
            Seq.fold (
                fun (acc : seq<string>) items ->
                    common2 [] (List.ofSeq (Seq.zip acc (splitBySeparator items)))
            ) (splitBySeparator (Seq.head argseq)) (Seq.skip 1 argseq)
            |> Seq.toArray

    printfn "The common preffix is: %A" (String.Join("/", (commonPrefix args)))
    0
