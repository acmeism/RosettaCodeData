using Primes

function collapse(n::Array{<:Integer})
    sum = 0
    for (p, d) in enumerate(n)
        sum += d * 10 ^ (p - 1)
    end
    return sum
end

Base.reverse(n::Integer) = collapse(reverse(digits(n)))
isemirp(n::Integer) = (if isprime(n) m = reverse(n); return m != n && isprime(m) end; false)

function firstnemirps(m::Integer)
    rst = zeros(typeof(m), m)
    i, n = 1, 2
    while i ≤ m
        if isemirp(n)
            rst[i] = n
            i += 1
        end
        n += 1
    end
    return rst
end

emirps = firstnemirps(10000)
println("First 20:\n", emirps[1:20])
println("Between 7700 and 8000:\n", filter(x -> 7700 ≤ x ≤ 8000, emirps))
println("10000th:\n", emirps[10000])
