using Primes

function nextby6(n, a)
    top = length(a)
    i = n + 1
    j = n + 2
    k = n + 3
    if n >= top
        return n
    end
    possiblenext = a[n] + 6
    if i <= top && possiblenext == a[i]
        return i
    elseif j <= top && possiblenext == a[j]
        return j
    elseif k <= top && possiblenext == a[k]
        return k
    end
    return n
end

function lastones(dict, n)
    arr = sort(collect(keys(dict)))
    beginidx = max(1, length(arr) - n + 1)
    arr[beginidx: end]
end

function lastoneslessthan(dict, n, ceiling)
    arr = filter(y -> y < ceiling, lastones(dict, n+3))
    beginidx = max(1, length(arr) - n + 1)
    arr[beginidx: end]
end

function primesbysexiness(x)
    twins = Dict{Int64, Array{Int64,1}}()
    triplets = Dict{Int64, Array{Int64,1}}()
    quadruplets = Dict{Int64, Array{Int64,1}}()
    quintuplets = Dict{Int64, Array{Int64,1}}()
    possibles = primes(x + 30)
    singles = filter(y -> y <= x - 6, possibles)
    unsexy = Dict(p => true for p in singles)
    for (i, p) in enumerate(singles)
        twinidx = nextby6(i, possibles)
        if twinidx > i
            delete!(unsexy, p)
            delete!(unsexy, p + 6)
            twins[p] = [i, twinidx]
            tripidx = nextby6(twinidx, possibles)
            if tripidx > twinidx
                triplets[p] = [i, twinidx, tripidx]
                quadidx = nextby6(tripidx, possibles)
                if quadidx > tripidx
                    quadruplets[p] = [i, twinidx, tripidx, quadidx]
                    quintidx = nextby6(quadidx, possibles)
                    if quintidx > quadidx
                        quintuplets[p] = [i, twinidx, tripidx, quadidx, quintidx]
                    end
                end
            end
        end
    end
    # Find and display the count of each group
    println("There are:\n$(length(twins)) twins,\n",
            "$(length(triplets)) triplets,\n",
            "$(length(quadruplets)) quadruplets, and\n",
            "$(length(quintuplets)) quintuplets less than $x.")
    println("The last 5 twin primes start with ", lastoneslessthan(twins, 5, x - 6))
    println("The last 5 triplet primes start with ", lastones(triplets, 5))
    println("The last 5 quadruplet primes start with ", lastones(quadruplets, 5))
    println("The quintuplet primes start with ", lastones(quintuplets, 5))
    println("There are $(length(unsexy)) unsexy primes less than $x.")
    lastunsexy = sort(collect(keys(unsexy)))[length(unsexy) - 9: end]
    println("The last 10 unsexy primes are: $lastunsexy")
end

primesbysexiness(1000035)
