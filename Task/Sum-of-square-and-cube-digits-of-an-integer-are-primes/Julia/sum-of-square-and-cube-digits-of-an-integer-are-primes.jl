using Primes

is_sqcubsumprime(n) = isprime(sum(digits(n*n))) && isprime(sum(digits(n*n*n)))
println(filter(is_sqcubsumprime, 1:100)) # [16, 17, 25, 28, 34, 37, 47, 52, 64]
