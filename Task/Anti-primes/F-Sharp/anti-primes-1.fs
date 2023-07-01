// Find Antı-Primes. Nigel Galloway: Secember 10th., 2018
let  N=200000000000000000000000000I
let fI,_=Seq.scan(fun (_,g) e->(e,e*g)) (2I,4I) (primes|>Seq.skip 1|>Seq.map bigint)|>Seq.takeWhile(fun(_,n)->n<N)|>List.ofSeq|>List.unzip
let fG g=Seq.unfold(fun ((n,i,e) as z)->Some(z,(n+1,i+1,(e*g)))) (1,2,g)|>Seq.takeWhile(fun(_,_,n)->n<N)
let fE n i=n|>Seq.collect(fun(n,e,g)->Seq.map(fun(a,c,b)->(a,c*e,g*b)) (i|>Seq.takeWhile(fun(g,_,_)->g<=n)) |> Seq.takeWhile(fun(_,_,n)->n<N))
let fL,_=Seq.concat(Seq.scan(fun n g->fE n (fG g)) (seq[(2147483647,1,1I)]) fI)|>List.ofSeq|>List.sortBy(fun(_,_,n)->n)|>List.fold(fun ((a,b) as z) (_,n,g)->if n>b then ((n,g)::a,n) else z) ([],0)
