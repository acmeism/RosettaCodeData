// Ormiston triples. Nigel Galloway: February 3rd., 2023
let oTriples n=n|>Seq.pairwise|>Seq.filter(fun((n,i),(g,l))->i=g)|>Seq.map(fun((n,i),(g,l))->(n,g,l))
primes32()|>oPairs|>oTriples|>Seq.take 25|>Seq.iter(fun(n,_,_)->printf "%d " n); printfn ""
printfn $"<100 million: %d{primes32()|>Seq.takeWhile((>)100000000)|>oPairs|>oTriples|>Seq.length}"
printfn $"<1 billion: %d{primes32()|>Seq.takeWhile((>)1000000000)|>oPairs|>oTriples|>Seq.length}"
