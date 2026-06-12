// 2n+1 is prime. Nigel Galloway: Januuary 22nd., 2022
primes32()|>Seq.skip 1|>Seq.take 20|>Seq.map(fun n->n/2)|>Seq.iteri(fun n g->printfn "%2d: %2d + %2d=%d" (n+1) g (g+1) (g+g+1))
