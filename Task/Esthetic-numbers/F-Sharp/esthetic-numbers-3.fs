Esthetic 10|>Seq.map(EtoS>>int)|>Seq.skipWhile(fun n->n<1000)|>Seq.takeWhile(fun n->n<9999)|>Seq.iter(printfn "%d");;
