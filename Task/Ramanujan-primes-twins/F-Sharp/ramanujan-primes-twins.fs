// Twin Ramanujan primes. Nigel Galloway: September 9th., 2021
printfn $"There are %d{rP 1000000|>Seq.pairwise|>Seq.filter(fun(n,g)->n=g-2)|>Seq.length} twins in the first million Ramanujan primes"
