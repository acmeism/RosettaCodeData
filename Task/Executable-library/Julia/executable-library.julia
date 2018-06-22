############### in file hailstone.jl ###############
module Hailstone

function hailstone(n)
    ret = [n]
    while n > 1
        if n & 1 > 0
            n = 3n + 1
        else
            n = Int(n//2)
        end
        append!(ret, n)
    end
    return ret
end

export hailstone

end

if PROGRAM_FILE == "hailstone.jl"
    using Hailstone
    h = hailstone(27)
    n = length(h)
    println("The sequence of hailstone(27) is:\n $h.\nThis sequence is of length $n. It starts with $(h[1:4]) and ends with $(h[n-3:end]).")
end
############ in file moduletest.jl ####################
include("hailstone.jl")
using Hailstone
function countstones(mi, mx)
    lengths2occurences = Dict()
    mostfreq = mi
    maxcount = 1
    for i in mi:mx
        h = hailstone(i)
        n = length(h)
        if haskey(lengths2occurences, n)
            newoccurences = lengths2occurences[n] + 1
            if newoccurences > maxcount
                maxcount = newoccurences
                mostfreq = n
            end
            lengths2occurences[n] = newoccurences
        else
            lengths2occurences[n] = 1
        end
    end
    mostfreq, maxcount
end

nlen, cnt = countstones(1,99999)

print("The most common hailstone sequence length for hailstone(n) for 1 <= n < 100000 is $nlen, which occurs $cnt times.")
