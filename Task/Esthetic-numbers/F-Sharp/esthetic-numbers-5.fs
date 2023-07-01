Esthetic 10|>Seq.map(EtoS>>int64)|>Seq.skipWhile(fun n->n<100000000000L)|>Seq.takeWhile(fun n->n<130000000000L)|>Seq.iter(printfn "%d")
