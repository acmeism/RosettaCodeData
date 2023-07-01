// Equal prime and composite sums. Nigel Galloway: March 3rd., 2022
let fN(g:seq<int64>)=let g=(g|>Seq.scan(fun(_,n,i) g->(g,n+g,i+1))(0,0L,0)|>Seq.skip 1).GetEnumerator() in (fun()->g.MoveNext()|>ignore; g.Current)
let fG n g=let rec fG a b=seq{match a,b with ((_,p,_),(_,c,_)) when p<c->yield! fG(n()) b |((_,p,_),(_,c,_)) when p>c->yield! fG a (g()) |_->yield(a,b); yield! fG(n())(g())} in fG(n())(g())
fG(fN(primes64()))(fN(primes64()|>Seq.pairwise|>Seq.collect(fun(n,g)->[1L+n..g-1L])))|>Seq.take 11|>Seq.iter(fun((n,i,g),(e,_,l))->printfn $"Primes up to %d{n} at position %d{g} and composites up to %d{e} at position %d{l} sum to %d{i}.")
