// Generate Latin Squares in reduced form. Nigel Galloway: July 10th., 2019
let normLS α=
  let N=derange α|>List.ofSeq|>List.groupBy(fun n->n.[0])|>List.sortBy(fun(n,_)->n)|>List.map(fun(_,n)->n)|>Array.ofList
  let rec fG n g=match n with h::t->fG t (g|>List.filter(fun g->Array.forall2((<>)) h g )) |_->g
  let rec normLS n g=seq{for i in fG n N.[g] do if g=α-2 then yield [|1..α|]::(List.rev (i::n)) else yield! normLS (i::n) (g+1)}
  match α with 1->seq[[[|1|]]] |2-> seq[[[|1;2|];[|2;1|]]] |_->Seq.collect(fun n->normLS [n] 1) N.[0]
