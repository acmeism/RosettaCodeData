""" Rosetta code task: rosettacode.org/wiki/Zsigmondy_numbers """

using Primes

function divisors(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    return length(f) == 1 ? [one(n), n] : sort!(f)
end

function Zs(n, a, b)
    @assert a > b
    dexpms = map(i -> a^i - b^i, 1:n-1)
    dexpn = a^n - b^n
    return maximum(filter(d -> all(k -> gcd(k, d) == 1, dexpms), divisors(dexpn)))
end

tests = [(2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (3, 2), (5, 3), (7, 3), (7, 5)]
for (a, b) in tests
    println("\nZsigmondy(n, $a, $b): ", join([Zs(n, a, b) for n in 1:20], ", "))
end
