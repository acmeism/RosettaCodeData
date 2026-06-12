using Primes

makesprimetriplet(n) = all(isprime, [n - 1, n + 3, n + 5])
println(" N       Prime Triplet\n--------------------------")
foreach(n -> println(rpad(n, 6), [n - 1, n + 3, n + 5]), filter(makesprimetriplet, 2:6005))
