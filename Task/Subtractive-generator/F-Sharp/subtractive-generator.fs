[<EntryPoint>]
let main argv =
    let m = 1000000000
    let init = Seq.unfold (fun ((i, s2, s1)) -> Some((s2,i), (i+1, s1, (m+s2-s1)%m))) (0, 292929, 1)
            |> Seq.take 55
            |> Seq.sortBy (fun (_,i) -> (34*i+54)%55)
            |> Seq.map fst
    let rec r = seq {
        yield! init
        yield! Seq.map2 (fun u v -> (m+u-v)%m) r (Seq.skip 31 r)
    }

    r |> Seq.skip 220 |> Seq.take 3
    |> Seq.iter (printfn "%d")
    0
