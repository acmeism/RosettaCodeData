using Lazy
using Primes

function containsitsonlytwodigfactors(n)
    s = string(n)
    return !isprime(n) && all(t -> length(t) > 1 && contains(s, t), map(string, collect(keys(factor(n)))))
end

seq = @>> Lazy.range(2) filter(containsitsonlytwodigfactors)

foreach(p -> print(lpad(last(p), 9), first(p) == 10 ? "\n" : ""), enumerate(take(20, seq)))
