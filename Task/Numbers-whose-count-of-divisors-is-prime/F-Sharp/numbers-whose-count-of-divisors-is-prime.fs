// Numbers whose divisor count is prime. Nigel Galloway: July 13th., 2021
primes64()|>Seq.takeWhile(fun n->n*n<100000L)|>Seq.collect(fun n->primes32()|>Seq.skip 1|>Seq.map(fun g->pown n (g-1))|>Seq.takeWhile((>)100000L))|>Seq.sort|>Seq.iter(printf "%d "); printfn ""
