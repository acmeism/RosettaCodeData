using Primes

btsumsareprime(n) = isprime(sum(digits(n, base=2))) && isprime(sum(digits(n, base=3)))

foreach(p -> print(rpad(p[2], 4), p[1] % 20 == 0 ? "\n" : ""), enumerate(filter(btsumsareprime, 1:199)))
