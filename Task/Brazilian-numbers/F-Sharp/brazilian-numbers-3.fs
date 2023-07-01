Brazilian() |> Seq.filter(fun n->n%2=1) |> Seq.take 20 |> Seq.iter(printf "%d "); printfn ""
