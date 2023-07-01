[0..9]|>Seq.iter(fun n->printfn "first umprimable number ending in %d is %d" n (uP()|>Seq.find(fun g->n=g%10)))
