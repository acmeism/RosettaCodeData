""" rosettacode.org/wiki/No_prime_sums """

using Primes

@enum Parity BOTH = 1 EVEN ODD

const KINDS = ["", "odd ", "even "]

const primesieve = primesmask(100_000_000)

function noprimesums(start, limit, kind)
    step = kind == BOTH ? 1 : 2
    k = kind == EVEN ? 2 : 3
    sums = [0, start]
    res = [start]
    while length(res) < limit
        while any(s -> primesieve[k+s], sums)
            k += step
        end
        if kind == BOTH || kind == ODD && isodd(k) || kind == EVEN && iseven(k)
            append!(sums, sums .+ k)
            push!(res, k)
        end
        k += step
    end
    return res
end

function testnoprimesums(limit = 10)
    Threads.@threads for kind in (BOTH, ODD, EVEN)
        @time a = noprimesums(1, limit, kind)
        println("lexicographically earliest $(KINDS[Int(kind)])",
           "integer such that no subsequence sums to a prime:\n$a\n")
    end
end

testnoprimesums()
