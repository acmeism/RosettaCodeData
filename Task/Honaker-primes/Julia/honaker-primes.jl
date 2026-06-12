""" Rosetta code task: rosettacode.org/wiki/Honaker_primes """

using Formatting
using Primes

""" Get the sequence of Honaker primes as tuples with their primepi values first in tuple"""
honaker(lim) = [(i, p) for (i, p) in enumerate(primes(lim)) if sum(digits(p)) == sum(digits(i))]

println("First 50 Honaker primes:")
const a = honaker(5_000_000)
foreach(p -> print(rpad(p[2], 12), p[1] % 5 == 0 ? "\n" : ""), enumerate(a[1:50]))
println("\n$(format(a[10000][2], commas = true)) is the ",
        "$(format(a[10000][1], commas = true))th prime and the 10,000th Honaker prime.")
