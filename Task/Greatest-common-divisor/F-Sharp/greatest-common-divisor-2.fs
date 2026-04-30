// GCD method attributed to Dijkstra. Nigel Galloway: February 7th., 2026.
let rec gcd n=function g when n=g->n
                      |g when n<g->gcd (g-n) n
                      |g->gcd g (n-g)
printfn "%d, %d, %d" (gcd 23 13) (gcd 600 400) (gcd 0 0)
