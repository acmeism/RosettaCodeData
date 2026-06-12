using Primes

issquare(i::Integer) = i == isqrt(i)^2
istwinprime(p) = isprime(p) && isprime(p + 2)
issquaretwinprime(p) = istwinprime(p) && issquare(p + p + 2)

for n in filter(issquaretwinprime, 1:10_000_000)
    println(isqrt(2n + 2), "^2 = ", n, " + ", n + 2)
end
