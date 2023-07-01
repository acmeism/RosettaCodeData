using Primes, Combinatorics

function primepartition(x::Int64, n::Int64)
    if n == oftype(n, 1)
        return isprime(x) ? [x] : Int64[]
    else
        for combo in combinations(primes(x), n)
            if sum(combo) == x
                return combo
            end
        end
    end
    return Int64[]
end

for (x, n) in [[   18, 2], [   19, 3], [   20,  4], [99807, 1], [99809, 1],
         [ 2017, 24],[22699, 1], [22699, 2], [22699,  3], [22699, 4] ,[40355, 3]]
    ans = primepartition(x, n)
    println("Partition of ", x, " into ", n, " primes: ",
        isempty(ans) ? "impossible" : join(ans, " + "))
end
