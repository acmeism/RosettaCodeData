using Primes

function specialneighbors(N, savepairs=true)
    neighbors, p1, pcount = Pair{Int}[], 2, 0
    while (p2 = nextprime(p1 + 1)) < N
        if isprime(p2 + p1 - 1)
            savepairs && push!(neighbors, p1 => p2)
            pcount += 1
        end
        p1 = p2
    end
    return neighbors, pcount
end

spn, n = specialneighbors(100)
println("$n special neighbor prime pairs under 100:")
println("p1   p2   p1 + p2 - 1\n--------------------------")
for (p1, p2) in specialneighbors(100)[1]
    println(lpad(p1, 2), "   ", rpad(p2, 7), p1 + p2 - 1)
end

print("\nCount of such prime pairs under 1,000,000,000: ",
    specialneighbors(1_000_000_000, false)[2])
