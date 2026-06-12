using Primes

for (i, p) in enumerate(filter(x -> isprime(2x + 1), primes(1500)))
    print(lpad(p, 5), i % 10 == 0 ? "\n" : "")
end
