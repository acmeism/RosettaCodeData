// Erdös-Selfridge categorization of primes. Nigel Galloway: April 12th., 2022
let rec fG n g=match n,g with ((_,1),_)|(_,[])->n |((_,p),h::_) when h>p->n |((p,q),h::_) when q%h=0->fG (p,q/h) g |(_,_::g)->fG n g
let fN g=Seq.unfold(fun(n,g)->let n,g=n|>List.map(fun n->fG n g)|>List.partition(fun(_,n)->n<>1) in let g=g|>List.map fst in if g=[] then None else Some(g,(n,g)))(primes32()|>Seq.take g|>Seq.map(fun n->(n,n+1))|>List.ofSeq,[2;3])
fN 200|>Seq.iteri(fun n g->printfn "Category %d: %A" (n+1) g)
fN 1000000|>Seq.iteri(fun n g->printfn "Category %d: first->%d last->%d count->%d" (n+1) (List.head g) (List.last g) (
