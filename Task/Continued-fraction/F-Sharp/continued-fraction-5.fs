let pi = π [3M;7M;15M;1M;292M;1M;1M;1M;2M;1M;3M;1M;14M;2M;1M;1M;2M;2M;2M;2M]
cN2S pi |> Seq.take 10 |> Seq.pairwise |> Seq.iter(fun(n,g)->printfn "%1.14f < π < %1.14f" (min n g) (max n g))
