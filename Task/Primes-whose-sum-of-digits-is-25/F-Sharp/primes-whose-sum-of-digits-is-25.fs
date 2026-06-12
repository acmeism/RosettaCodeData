// Primes  to 5000 who's sum of digits is 25. Nigel Galloway: April 1st., 2021
let rec fN g=function n when n<10->n+g=25 |n->fN(g+n%10)(n/10)
primes32()|>Seq.takeWhile((>)5000)|>Seq.filter fN|>Seq.iter(printf "%d "); printfn ""
