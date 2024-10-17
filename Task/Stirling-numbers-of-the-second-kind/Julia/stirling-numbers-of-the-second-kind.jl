using Combinatorics

const s2cache = Dict()

function stirlings2(n, k)
    if haskey(s2cache, Pair(n, k))
        return s2cache[Pair(n, k)]
    elseif n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n == k == 0
        return one(n)
    elseif n == 0 || k == 0
        return zero(n)
    elseif k == n - 1
        return binomial(n, 2)
    elseif k == 2
        return 2^(n-1) - 1
    end

    ret = k * stirlings2(n - 1, k) + stirlings2(n - 1, k - 1)
    s2cache[Pair(n, k)] = ret
    return ret

end

function printstirling2table(kmax)
    println("  ", mapreduce(i -> lpad(i, 10), *, 0:kmax))

    sstring(n, k) = begin i = stirlings2(n, k); lpad(k > n && i == 0 ? "" : i, 10) end

    for n in 0:kmax
        println(rpad(n, 2) * mapreduce(k -> sstring(n, k), *, 0:kmax))
    end
end

printstirling2table(12)
println("\nThe maximum for stirling2(100, _) is: ", maximum(k-> stirlings2(BigInt(100), BigInt(k)), 1:100))
