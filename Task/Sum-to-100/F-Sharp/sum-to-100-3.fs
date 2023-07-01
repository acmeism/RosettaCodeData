let n,g = N |> Seq.filter(fun n->n.g>=0) |> Seq.countBy(fun n->n.g) |> Seq.maxBy(snd)
printfn "%d has %d solutions" n g
