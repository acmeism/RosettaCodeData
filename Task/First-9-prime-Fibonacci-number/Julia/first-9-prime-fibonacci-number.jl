using Lazy
using Primes

fibs = @lazy big"0":big"1":(fibs + drop(1, fibs))

primefibs = @>> fibs filter(isprime)

println(take(9, primefibs)) # List: (2 3 5 13 89 233 1597 28657 514229)
