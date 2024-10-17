using Printf, Primes
using DataStructures

function counttransitions(upto::Integer)
    cnt = counter(Pair{Int,Int})
    tot = 0
    prv, nxt = 2, 3
    while nxt ≤ upto
        push!(cnt, prv % 10 => nxt % 10)
        prv = nxt
        nxt = nextprime(nxt + 1)
        tot += 1
    end
    return sort(Dict(cnt)), tot - 1
end

trans, tot = counttransitions(100_000_000)

println("First 100_000_000 primes, last digit transitions:")
for ((i, j), fr) in trans
    @printf("%i → %i: freq. %3.4f%%\n", i, j, 100fr / tot)
end
