// Special neighbor primes. Nigel Galloway: August 6th., 2021
pCache|>Seq.pairwise|>Seq.takeWhile(snd>>(>)100)|>Seq.filter(fun(n,g)->isPrime(n+g-1))|>Seq.iter(printfn "%A")
