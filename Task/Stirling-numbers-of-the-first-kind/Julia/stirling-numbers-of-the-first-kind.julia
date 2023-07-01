using Combinatorics

const s1cache = Dict()

function stirlings1(n, k, signed::Bool=false)
    if signed == true && isodd(n - k)
        return -stirlings1(n, k)
    elseif haskey(s1cache, Pair(n, k))
        return s1cache[Pair(n, k)]
    elseif n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n == k == 0
        return one(n)
    elseif n == 0 || k == 0
        return zero(n)
    elseif n == k
        return one(n)
    elseif k == 1
        return factorial(n-1)
    elseif k == n - 1
        return binomial(n, 2)
    elseif k == n - 2
        return div((3 * n - 1) * binomial(n, 3), 4)
    elseif k == n - 3
        return binomial(n, 2) * binomial(n, 4)
    end

    ret = (n - 1) * stirlings1(n - 1, k) + stirlings1(n - 1, k - 1)
    s1cache[Pair(n, k)] = ret
    return ret
end

function printstirling1table(kmax)
    println("  ", mapreduce(i -> lpad(i, 10), *, 0:kmax))

    sstring(n, k) = begin i = stirlings1(n, k); lpad(k > n && i == 0 ? "" : i, 10) end

    for n in 0:kmax
        println(rpad(n, 2) * mapreduce(k -> sstring(n, k), *, 0:kmax))
    end
end

printstirling1table(12)
println("\nThe maximum for stirling1(100, _) is:\n", maximum(k-> stirlings1(BigInt(100), BigInt(k)), 1:100))
