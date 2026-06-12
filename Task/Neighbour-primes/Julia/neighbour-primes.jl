using Primes

isneiprime(known) = isprime(known) && isprime(known * nextprime(known + 1) + 2)
println(filter(isneiprime, primes(500)))
