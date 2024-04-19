// N-grams. Nigel Galloway: April 11th., 2024
let fN g=let n,g=g@[0I],0I::g in List.map2(fun n g->n-g) n g
Seq.unfold(fun g->Some(g,fN g))[1I]|>Seq.take 9|>Seq.iteri(fun n g->printfn "%d -> %A" n g); printfn ""
let fG (n::g) l=(n+1I)%l=0I && g|>List.forall(fun n->n%l=0I)
Seq.unfold(fun(n,g)->Some((n,g),(n+1I,fN g)))(0I,[1I])|>Seq.skip 2|>Seq.filter(fun(n,_::g)->fG (List.rev g) n)|>Seq.takeWhile(fun(n,_)->n<100I)|>Seq.iter(fun(n,_)->printf "%A " n); printfn ""
