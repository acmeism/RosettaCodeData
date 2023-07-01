using Primes

function maxprimebases(ndig, maxbase)
    maxprimebases = [Int[]]
    nwithbases = ["0"]
    for tup in Iterators.product([0:maxbase-1 for _ in 1:ndig - 1]..., 1:maxbase-1)
        dig = collect(tup)
        foundbases = Int[]
        for b in maximum(dig)+1:maxbase
            if isprime(evalpoly(b, dig))
                push!(foundbases, b)
            end
            maxbase - b + length(foundbases) < length(maxprimebases) && break # shortcut if hopeless
        end
        if length(foundbases) > length(first(maxprimebases))
            maxprimebases = [foundbases]
            nwithbases = [prod(string.(reverse(dig), base = any(x -> x > 9, dig) ? 32 : 10))]
        elseif length(foundbases) == length(first(maxprimebases))
            push!(maxprimebases, foundbases)
            push!(nwithbases, prod(string.(reverse(dig), base = any(x -> x > 9, dig) ? 32 : 10)))
        end
    end
    alen, vlen = length(first(maxprimebases)), length(maxprimebases)
    println("\nThe maximum number of prime valued bases for base up to $maxbase numeric strings of length ",
        ndig, " is $alen. The value list of ", vlen > 1 ? "these" : "this", " is:")
    for i in eachindex(maxprimebases)
        println(nwithbases[i], maxprimebases[i][1] > 10 ? "(base 32)" : "", " => ", maxprimebases[i])
    end
end

for n in 1:5
    maxprimebases(n, 36)
    maxprimebases(n, 62)
end
