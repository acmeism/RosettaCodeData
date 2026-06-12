// Largest difference between adjacent primes. Nigel Galloway: November 22nd., 2021
let n,g=primes32()|>Seq.takeWhile((>)1000000)|>Seq.pairwise|>Seq.maxBy(fun(n,g)->g-n) in printfn $"%d{g}-%d{n}=%d{g-n}"
