using Lazy
using Primes

cullen(n, two = BigInt(2)) = n * two^n + 1
woodall(n, two = BigInt(2)) = n * two^n - 1
primecullens = @>> Lazy.range() filter(n -> isprime(cullen(n)))
primewoodalls = @>> Lazy.range() filter(n -> isprime(woodall(n)))

println("First 20 Cullen numbers: ( n × 2**n + 1)\n", [cullen(n, 2) for n in 1:20]) # A002064
println("First 20 Woodall numbers: ( n × 2**n - 1)\n", [woodall(n, 2) for n in 1:20]) # A003261
println("\nFirst 5 Cullen primes: (in terms of n)\n",  take(5, primecullens))  # A005849
println("\nFirst 12 Woodall primes: (in terms of n)\n", Int.(collect(take(12, primewoodalls)))) # A002234
