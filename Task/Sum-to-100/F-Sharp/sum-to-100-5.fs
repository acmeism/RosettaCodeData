N |> Seq.filter(fun n->n.g>=0) |> Seq.distinctBy(fun n->n.g) |> Seq.sortBy(fun n->(-n.g)) |> Seq.take 10 |> Seq.iter(fun n->printfn "%d" n.g )
