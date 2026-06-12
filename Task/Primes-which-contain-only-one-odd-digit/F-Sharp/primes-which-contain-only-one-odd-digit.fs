// Primes which contain only one odd number. Nigel Galloway: July 28th., 2021
let rec fN g=function 2->false |n when g=0->n=1 |n->fN (g/10) (n+g%2)
primes32()|>Seq.takeWhile((>)1000)|>Seq.filter(fun g->fN g 0)|>Seq.iter(printf "%d "); printfn ""
