using Primes, Combinatorics

function antiprimes(N, maxn = 2000000)
    antip = [1]  # special case: 1 is antiprime
    count = 1
    maxfactors = 1
    for i in 2:2:maxn # antiprimes > 2 should be even
        lenfac = length(unique(sort(collect(combinations(factor(Vector, i)))))) + 1
        if lenfac > maxfactors
            push!(antip, i)
            if length(antip) >= N
                return antip
            end
            maxfactors = lenfac
        end
    end
    antip
end

println("The first 20 anti-primes are:\n", antiprimes(20))
println("The first 40 anti-primes are:\n", antiprimes(40))
