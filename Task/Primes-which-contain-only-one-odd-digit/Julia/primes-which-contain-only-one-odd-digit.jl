using Primes

function isoneoddprime(n, base = 10)
    d = digits(n ÷ base, base = base)
    return n != 2 && all(iseven, d)
end

found = filter(isoneoddprime, primes(1000))
println("Found $(length(found)) primes with one odd digit in base 10:")
foreach(p -> print(rpad(last(p), 5), first(p) % 9 == 0 ? "\n" : ""), enumerate(found))

println("\nThere are ", count(isoneoddprime, primes(1_000_000)),
    " primes with only one odd digit in base 10 between 1 and 1,000,000.")
