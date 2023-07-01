Esthetic 10|>Seq.map(EtoS>>int)|>Seq.skipWhile(fun n->n<100000000)|>Seq.takeWhile(fun n->n< 130000000)|>Seq.iter(printfn "%d")
