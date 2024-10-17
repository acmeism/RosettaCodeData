using Combinatorics, Primes

combodigits(len) = sort!(unique(map(y -> join(y, ""), with_replacement_combinations("2357", len))))

function getprimes(N, maxdigits=9)
    ret = [2, 3, 5, 7]
    perms = Int[]
    for i in 1:maxdigits-1, combo in combodigits(i), perm in permutations(combo)
        n = parse(Int64, String(perm)) * 10
        push!(perms, n + 3, n + 7)
    end
        for perm in sort!(perms)
        if isprime(perm) && !(perm in ret)
            push!(ret, perm)
            if length(ret) >= N
                return ret
            end
        end
    end
end

const v = getprimes(10000)
println("The first 25 Smarandache primes are: ", v[1:25])
println("The 100th Smarandache prime is: ", v[100])
println("The 10000th Smarandache prime is: ", v[10000])
