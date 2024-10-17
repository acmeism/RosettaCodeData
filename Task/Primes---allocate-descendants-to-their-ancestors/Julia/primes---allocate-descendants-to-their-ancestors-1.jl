using Primes

function ancestraldecendants(maxsum)
    aprimes = primes(maxsum)
    descendants = [Vector{Int}() for _ in 1:maxsum + 1]
    ancestors = [Vector{Int}() for _ in 1:maxsum + 1]
    for p in aprimes
        push!(descendants[p + 1], p)
        foreach(s -> append!(descendants[s + p], [p * pr for pr in descendants[s]]),
            2:length(descendants) - p)
    end
    foreach(p -> pop!(descendants[p + 1]), vcat(aprimes, [4]))
    total = 0
    for s in 1:maxsum
        sort!(descendants[s + 1])
        dstlen = length(descendants[s + 1])
        total += dstlen
        idx = findfirst(x -> x > maxsum, descendants[s + 1])
        idx  = (idx == nothing) ? dstlen : idx - 1
        foreach(d -> ancestors[d] = vcat(ancestors[s + 1], [s]), descendants[s + 1][1:idx])
        if s in vcat(collect(0:20), 46, 74, 99)
            print(lpad(s, 3), ":", lpad("$(length(ancestors[s + 1]))", 2))
            print(" Ancestor(s):", rpad("$(ancestors[s + 1])", 18))
            print(lpad("$(length(descendants[s + 1]))", 5), " Descendant(s): ")
            println(rpad(dstlen <= 10 ? "$(descendants[s + 1])" : "$(descendants[s + 1][1:10])\b, ...]", 40))
        end
    end
    print("Total descendants: ", total)
end

ancestraldecendants(99)
