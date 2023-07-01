using Printf

function sternbrocot(f::Function=(x) -> length(x) ≥ 20)::Vector{Int}
    rst = Int[1, 1]
    i = 2
    while !f(rst)
        append!(rst, Int[rst[i] + rst[i-1], rst[i]])
        i += 1
    end
    return rst
end

println("First 15 elements of Stern-Brocot series:\n", sternbrocot(x -> length(x) ≥ 15)[1:15], "\n")

for i in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100)
    occurr = findfirst(x -> x == i, sternbrocot(x -> i ∈ x))
    @printf("Index of first occurrence of %3i in the series: %4i\n", i, occurr)
end

print("\nAssertion: the greatest common divisor of all the two\nconsecutive members of the series up to the 1000th member, is always one: ")
sb = sternbrocot(x -> length(x) > 1000)
if all(gcd(prev, this) == 1 for (prev, this) in zip(sb[1:1000], sb[2:1000]))
    println("Confirmed.")
else
    println("Rejected.")
end
