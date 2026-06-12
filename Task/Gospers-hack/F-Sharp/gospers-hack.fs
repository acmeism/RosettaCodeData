// Gosper's hack. Nigel Galloway: July 29th., 2025
let fN g=let n=g &&& -g in ((((n+g)^^^g)>>>2)/n)|||(n+g)
let gH=Seq.unfold(fun g->Some(g,fN g))
[1;3;7;15;23]|>Seq.iter(fun n->gH n|>Seq.take 11|>Seq.iter(printf "%d "); printfn "")
