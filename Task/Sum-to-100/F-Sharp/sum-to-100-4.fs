match N |> Seq.filter(fun n->n.g>=0) |> Seq.distinctBy(fun n->n.g) |> Seq.sortBy(fun n->n.g) |> Seq.pairwise |> Seq.tryFind(fun n->(snd n).g-(fst n).g > 1) with
  |Some(n) -> printfn "least non-value is %d" ((fst n).g+1)
  |None    -> printfn "No non-values found"
