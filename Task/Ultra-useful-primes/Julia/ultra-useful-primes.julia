using Primes

nearpow2pow2prime(n) = findfirst(k -> isprime(2^(big"2"^n) - k), 1:10000)

@time println([nearpow2pow2prime(n) for n in 1:12])
