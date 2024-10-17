""" Rosetta Code task rosettacode.org/wiki/Sieve_of_Pritchard """

""" Pritchard sieve of primes up to limit. Uses type of `limit` arg for type of primes """
function pritchard(limit::T, verbose=false) where {T<:Integer}
    members = falses(limit)
    members[1] = true
    steplength = 1 # wheel size
    prime = T(2)
    primes = T[]
    nlimit = prime * steplength # wheel limit
    ac = 2 # added count, since adding 1 & 2 during initialization
    rc = 1 # removed count, since 1 will be removed at the end
    rtlim = T(isqrt(limit)) # this allows the main loop to go
    while prime < rtlim # one extra time, eliminating the follow-up for
        # the last partial wheel (if present)
        if steplength < limit
            for w in 1:steplength
                if members[w]
                    n = w + steplength
                    while n <= nlimit
                        members[n] = true
                        ac += 1
                        n += steplength
                    end
                end
            end
            steplength = nlimit # advance wheel size
        end
        np = 5
        mcopy = copy(members)
        for w in 1:nlimit
            if mcopy[w]
                np == 5 && w > prime && (np = w)
                n = prime * w
                n > nlimit && break
                rc += 1
                members[n] = false
            end
        end
        np < prime && break
        push!(primes, prime)
        prime = prime == 2 ? 3 : np
        nlimit = min(steplength * prime, limit) # advance wheel limit
    end
    members[1] = false
    newprimes = [i for i in eachindex(members) if members[i]]
    verbose && println(
        "up to $limit, added $ac, removed $rc, prime count ",
        length(primes) + length(newprimes),
    )
    return append!(primes, newprimes)
end

println(pritchard(150))
pritchard(1000000, true)
