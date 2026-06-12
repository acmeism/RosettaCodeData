// Prime triplets: Nigel Galloway. May 18th., 2021
primes32()|>Seq.takeWhile((>)6000)|>Seq.filter(fun n->isPrime(n+4)&&isPrime(n+6))|>Seq.iter((+)1>>printf "%d "); printfn ""
