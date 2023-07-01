XstarF 987654321UL|>Seq.take 100000|>Seq.countBy(fun n->int(n*5.0))|>Seq.iter(printf "%A");printfn ""
