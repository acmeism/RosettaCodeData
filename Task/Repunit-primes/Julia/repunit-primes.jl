using Primes

repunitprimeinbase(n, base) = isprime(evalpoly(BigInt(base), [1 for _ in 1:n]))

for b in 2:40
    println(rpad("Base $b:", 9), filter(n -> repunitprimeinbase(n, b), 1:2700))
end
