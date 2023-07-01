function islexless(a::AbstractArray{<:Real}, b::AbstractArray{<:Real})
    for (x, y) in zip(a, b)
        if x == y continue end
        return x < y
    end
    return length(a) < length(b)
end

using Primes, Combinatorics
tests = [[1, 2, 3], primes(10), 0:2:6, [-Inf, 0.0, Inf], [π, e, φ, catalan], [2015, 5], [-sqrt(50.0), 50.0 ^ 2]]
println("List not sorted:\n - ", join(tests, "\n - "))
sort!(tests; lt=islexless)
println("List sorted:\n - ", join(tests, "\n - "))
