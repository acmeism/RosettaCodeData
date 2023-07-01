// Tau number. Nigel Galloway: March 9th., 2021
Seq.initInfinite((+)1)|>Seq.filter(fun n->n%(tau n)=0)|>Seq.take 100|>Seq.iter(printf "%d "); printfn ""
