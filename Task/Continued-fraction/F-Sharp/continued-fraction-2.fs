cfSqRt 2M |> Seq.take 10 |> Seq.pairwise |> Seq.iter(fun(n,g)->printfn "%1.14f < √2 < %1.14f" (min n g) (max n g))
