[<EntryPoint>]
let main argv =
    let table1 = [27, "Jonah";
                18, "Alan";
                28, "Glory";
                18, "Popeye";
                28, "Alan"]
    let table2 = ["Jonah", "Whales";
                "Jonah", "Spiders";
                "Alan", "Ghosts";
                "Alan", "Zombies";
                "Glory", "Buffy"]
    let hash = Seq.groupBy (fun r -> snd r) table1
    table2
    |> Seq.collect (fun r ->
        hash
        |> Seq.collect (fun kv ->
            if (fst r) <> (fst kv) then []
            else (Seq.map (fun x -> (x, r)) (snd kv)) |> Seq.toList)
        )
    |> Seq.toList
    |> printfn "%A"
    0
