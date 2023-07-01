using Primes

primefactors(n) = collect(keys(factor(n)))

function ErdösSelfridge(n)
    highfactors = filter(>(3), primefactors(n + 1))
    category = 1
    while !isempty(highfactors)
        highfactors = unique(reduce(vcat, [filter(>(3), primefactors(a + 1)) for a in highfactors]))
        category += 1
    end
    return category
end

function testES(numshowprimes, numtotalprimes)
    println("First $numshowprimes primes by Erdös-Selfridge categories:")
    dict = Dict{Int, Vector{Int}}(i => [] for i in 1:5)
    for p in primes(prime(numshowprimes))
        push!(dict[ErdösSelfridge(p)], p)
    end
    for cat in 1:5
        println("$cat => ", dict[cat])
    end
    dict2 = Dict{Int, Tuple{Int, Int, Int}}(i => (0, 0, 0) for i in 1:11)
    println("\nTotals for first $numtotalprimes primes by Erdös-Selfridge categories:")
    for p in primes(prime(numtotalprimes))
        cat = ErdösSelfridge(p)
        fir, tot, las = dict2[cat]
        fir == 0 && (fir = p)
        dict2[cat] = (fir, tot + 1, p)
    end
    for cat in 1:11
        first, total, last = dict2[cat]
        println("Category", lpad(cat, 3), " => first:", lpad(first, 8), ", total:", lpad(total, 7), ", last:", last)
    end
end

testES(200, 1_000_000)
