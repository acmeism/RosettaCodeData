// Additive Primes. Nigel Galloway: March 22nd., 2021
let rec fN g=function n when n<10->n+g |n->fN(g+n%10)(n/10)
primes32()|>Seq.takeWhile((>)500)|>Seq.filter(fN 0>>isPrime)|>Seq.iter(printf "%d "); printfn ""
