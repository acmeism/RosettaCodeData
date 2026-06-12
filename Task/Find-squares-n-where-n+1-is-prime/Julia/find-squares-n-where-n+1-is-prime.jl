using Primes

isintegersquarebeforeprime(n) = isqrt(n)^2 == n && isprime(n + 1)

foreach(p -> print(lpad(last(p), 5)), filter(isintegersquarebeforeprime, 1:1000))
