using Primes

ispdc(n) = (ndivs = prod(collect(values(factor(n))).+ 1); ndivs > 2 && isprime(ndivs))

foreach(p -> print(rpad(p[2], 8), p[1] % 10 == 0 ? "\n" : ""), enumerate(filter(ispdc, 1:100000)))
