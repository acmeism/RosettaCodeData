using Primes

function isErdősNicolas_with_k(n)
    @assert n > 2
    d = [one(n)]
    for (p, e) in eachfactor(n)
        d = reduce(vcat, [d * p^j for j in 1:e], init=d)
    end
    sort!(d)
    pop!(d)
    len = length(d)
    (len < 2 || sum(d) <= n) && return false, 0
    for k in 2:len
        sum(@view d[1:k]) == n && return true, k
    end
    return false, 0
end

for n in 3:2_000_000
    isEN, k = isErdősNicolas_with_k(n)
    isEN && println(lpad(n, 8), " equals the sum of its first $k divisors.")
end
