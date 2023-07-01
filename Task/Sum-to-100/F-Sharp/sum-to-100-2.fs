N |> Seq.filter(fun n->n.g=100) |> Seq.iter(fun n->printfn "%s" n.n)
