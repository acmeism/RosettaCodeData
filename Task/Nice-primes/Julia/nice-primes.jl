using Primes

isnice(n, base=10) = isprime(n) && (mod1(n - 1, base - 1) + 1) in [2, 3, 5, 7, 11, 13, 17, 19]

filter_open_interval(500, 1000, isnice)
