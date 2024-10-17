using Primes
divisors(n) = foldl((a, (p, e)) -> vcat((a * [p^i for i in 0:e]')...), factor(n), init=[1])

isperfect(n) = sum(1 // d for d in divisors(n)) == 2

lo, hi = 2, 2^19
println("Perfect numbers between ", lo, " and ", hi, ": ", collect(filter(isperfect, lo:hi)))
