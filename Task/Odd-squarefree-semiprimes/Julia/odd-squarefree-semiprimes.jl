using Primes

twoprimeproduct(n) = (a = factor(n).pe; length(a) == 2 && all(p -> p[2] == 1, a))

special1k = filter(n -> isodd(n) && twoprimeproduct(n), 1:1000)

foreach(p -> print(rpad(p[2], 4), p[1] % 20 == 0 ? "\n" : ""), enumerate(special1k))
