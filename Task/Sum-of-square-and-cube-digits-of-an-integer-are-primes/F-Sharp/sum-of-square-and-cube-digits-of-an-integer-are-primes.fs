// Sum of square and cube digits of an integer are primes. Nigel Galloway: December 22nd., 2021
let rec fN g=function 0->g |n->fN(g+n%10)(n/10)
[1..99]|>List.filter(fun g->isPrime(fN 0 (g*g)) && isPrime(fN 0 (g*g*g)))|>List.iter(printf "%d "); printfn ""
