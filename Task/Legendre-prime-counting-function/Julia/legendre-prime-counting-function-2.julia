using Primes

const maxpi = 1_000_000_000
const memoφ = Dict{Vector{Int}, Int}()
const pₐ = primes(isqrt(maxpi))

function π(n)
    function φ(x, a)
        if !haskey(memoφ, [x, a])
            memoφ[[x, a]] = a == 0 ? x : φ(x, a - 1) - φ(x ÷ pₐ[a], a - 1)
        end
        return memoφ[[x, a]]
    end

    n < 2 && return 0
    a = π(isqrt(n))
    return φ(n, a) + a - 1
end

@time for i in 0:9
    println("10^", rpad(i, 5), π(10^i))
end

@time for i in 0:9
    println("10^", rpad(i, 5), π(10^i))
end
