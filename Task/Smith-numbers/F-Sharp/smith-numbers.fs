// Generate Smith Numbers. Nigel Galloway: November 6th., 2020
let fN g=Seq.unfold(fun n->match n with 0->None |_->Some(n%10,n/10)) g |> Seq.sum
let rec fG(n,g) p=match g%p with 0->fG (n+fN p,g/p) p |_->(n,g)
primes32()|>Seq.pairwise|>Seq.collect(fun(n,g)->[n+1..g-1])|>Seq.takeWhile(fun n->n<10000)
|>Seq.filter(fun g->fN g=fst(primes32()|>Seq.scan(fun n g->fG n g)(0,g)|>Seq.find(fun(_,n)->n=1)))
|>Seq.chunkBySize 20|>Seq.iter(fun n->Seq.iter(printf "%4d ") n; printfn "")
