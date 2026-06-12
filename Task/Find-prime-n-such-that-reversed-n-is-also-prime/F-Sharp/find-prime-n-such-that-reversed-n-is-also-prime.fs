// Reversible Primes. Nigel Galloway: March 22nd., 2021
let emirp2=let rec fN g=function |0->g |n->fN(g*10+n%10)(n/10) in primes32()|>Seq.filter(fN 0>>isPrime)
emirp2|>Seq.takeWhile((>)500)|>Seq.iter(printf "%d "); printfn ""
