pcgFloat(seed 987654321UL 1UL)|>Seq.take 100000|>Seq.countBy(fun n->int(n*5.0))|>Seq.iter(printf "%A");printfn ""
