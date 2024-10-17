using Primes

function maxprimebases(ndig, maxbase)
    maxprimebases = [Int[]]
    nwithbases = [0]
    maxprime = 10^(ndig) - 1
    for p in div(maxprime + 1, 10):maxprime
        dig = digits(p)
        bases = [b for b in 2:maxbase if (isprime(evalpoly(b, dig)) && all(i -> i < b, dig))]
        if length(bases) > length(first(maxprimebases))
            maxprimebases = [bases]
            nwithbases = [p]
        elseif length(bases) == length(first(maxprimebases))
            push!(maxprimebases, bases)
            push!(nwithbases, p)
        end
    end
    alen, vlen = length(first(maxprimebases)), length(maxprimebases)
    println("\nThe maximum number of prime valued bases for base 10 numeric strings of length ",
        ndig, " is $alen. The base 10 value list of ", vlen > 1 ? "these" : "this", " is:")
    for i in eachindex(maxprimebases)
        println(nwithbases[i], " => ", maxprimebases[i])
    end
end

@time for n in 1:6
    maxprimebases(n, 36)
end
