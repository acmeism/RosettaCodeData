// Find Antı-Primes plus. Nigel Galloway: April 9th., 2019
// Increasing the value 14 will increase the number of anti-primes plus found
let fI=primes|>Seq.take 14|>Seq.map bigint|>List.ofSeq
let N=Seq.reduce(*) fI
let fG g=Seq.unfold(fun ((n,i,e) as z)->Some(z,(n+1,i+1,(e*g)))) (1,2,g)
let fE n i=n|>Seq.collect(fun(n,e,g)->Seq.map(fun(a,c,b)->(a,c*e,g*b)) (i|>Seq.takeWhile(fun(g,_,_)->g<=n))|> Seq.takeWhile(fun(_,_,n)->n<N))
let fL=let mutable g=0 in (fun n->g<-g+1; n=g)
let n=Seq.concat(Seq.scan(fun n g->fE n (fG g)) (seq[(2147483647,1,1I)]) fI)|>List.ofSeq|>List.groupBy(fun(_,n,_)->n)|>List.sortBy(fun(n,_)->n)|>List.takeWhile(fun(n,_)->fL n)
for n,g in n do printfn "%d->%A" n (g|>List.map(fun(_,_,n)->n)|>List.min)
