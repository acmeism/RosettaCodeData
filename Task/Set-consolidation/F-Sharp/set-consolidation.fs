let (|SeqNode|SeqEmpty|) s =
    if Seq.isEmpty s then SeqEmpty
    else SeqNode ((Seq.head s), Seq.skip 1 s)

let SetDisjunct x y = Set.isEmpty (Set.intersect x y)

let rec consolidate s = seq {
    match s with
    | SeqEmpty -> ()
    | SeqNode (this, rest) ->
        let consolidatedRest = consolidate rest
        for that in consolidatedRest do
            if (SetDisjunct this that) then yield that
        yield Seq.fold (fun x y -> if not (SetDisjunct x y) then Set.union x y else x) this consolidatedRest
}

[<EntryPoint>]
let main args =
    let makeSeqOfSet listOfList = List.map (fun x -> Set.ofList x) listOfList |> Seq.ofList
    List.iter (fun x -> printfn "%A" (consolidate (makeSeqOfSet x))) [
        [["A";"B"]; ["C";"D"]];
        [["A";"B"]; ["B";"C"]];
        [["A";"B"]; ["C";"D"]; ["D";"B"]];
        [["H";"I";"K"]; ["A";"B"]; ["C";"D"]; ["D";"B"]; ["F";"G";"H"]]
    ]
    0
