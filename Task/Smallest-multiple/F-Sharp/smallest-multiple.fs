// Least Multiple. Nigel Galloway: October 22nd., 2021
let fG n g=let rec fN i=match i*g with g when n>g->fN g |_->i in fN g
let leastMult n=let fG=fG n in primes32()|>Seq.takeWhile((>=)n)|>Seq.map fG|>Seq.reduce((*))
printfn $"%d{leastMult 20}"
