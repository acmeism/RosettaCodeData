// Nigel Galloway. April 13th., 2021
primes32()|>Seq.pairwise|>Seq.takeWhile(fun(n,_)->n<500)|>Seq.filter(fun(n,g)->isPrime(n*g+2))|>Seq.iter(fun(n,g)->printfn "%d*%d=%d" n g (n*g+2))
