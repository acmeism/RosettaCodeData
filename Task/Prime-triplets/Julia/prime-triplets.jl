using Primes

pmask = primesmask(1, 5505)
foreach(n -> println([n, n + 2, n + 6]), filter(n -> pmask[n] && pmask[n + 2] && pmask[n + 6], 1:5500))
