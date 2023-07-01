let Q=Array.zeroCreate<int>100000 in fQ Q; printfn "%d" (Q|>Seq.pairwise|>Seq.sumBy(fun(n,g)->if n>g then 1 else 0))
