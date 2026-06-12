using Primes
p = primes(1000)
arr = filter(n -> isprime(n[2]), accumulate((x, y) -> (y, x[2] + y), p[1:2:length(p)], init = (0, 0)))
println(join(arr, "\n"))
