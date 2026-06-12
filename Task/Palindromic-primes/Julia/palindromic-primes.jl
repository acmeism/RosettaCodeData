using Primes

parray = [2, 3, 5, 7, 9, 11]

results = vcat(parray, filter(isprime, [100j + 10i + j for i in 0:9, j in 1:9]))

println(results)
