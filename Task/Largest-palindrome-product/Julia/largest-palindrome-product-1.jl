using Primes

function twoprodpal(factorlength)
    maxpal = Int128(10)^(2 * factorlength) - 1
    dig = digits(maxpal)
    halfnum = dig[1:length(dig)÷2]
    while any(halfnum .!= 0)
        prodnum = evalpoly(Int128(10), [reverse(halfnum); halfnum])
        facs = twofac(factorlength, prodnum)
        if !isempty(facs)
            println("For factor length $factorlength, $(facs[1]) * $(facs[2]) = $prodnum")
            break
        end
        halfnum = digits(evalpoly(Int128(10), halfnum) - 1)
    end
end

function twofac(faclength, prodnum)
    f = [one(prodnum)]
    for (p, e) in factor(prodnum)
        f = reduce(vcat, [f * p^j for j in 1:e], init=f)
    end
    possiblefacs = filter(x -> length(string(x)) == faclength, f)
    for i in possiblefacs
        j = prodnum ÷ i
        j ∈ possiblefacs && return sort([i, j])
    end
    return typeof(prodnum)[]
end

@Threads.threads for i in 2:12
    twoprodpal(i)
end
