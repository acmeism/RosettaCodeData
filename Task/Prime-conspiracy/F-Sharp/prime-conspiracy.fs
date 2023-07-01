// Prime Conspiracy. Nigel Galloway: March 27th., 2018
primes|>Seq.take 10000|>Seq.map(fun n->n%10)|>Seq.pairwise|>Seq.countBy id|>Seq.groupBy(fun((n,_),_)->n)|>Seq.sortBy(fst)
  |>Seq.iter(fun(_,n)->Seq.sortBy(fun((_,n),_)->n) n|>Seq.iter(fun((n,g),z)->printfn "%d -> %d ocurred %3d times" n g z))
