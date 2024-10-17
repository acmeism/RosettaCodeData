using Formatting
using Primes

function primegaps(limit = 10^9)
    c(n) = format(n, commas=true)
    pri = primes(limit * 5)
    gapstarts = Dict{Int, Int}()
    for i in 2:length(pri)
        get!(gapstarts, pri[i] - pri[i - 1], pri[i - 1])
    end
    pm, gap1 = 10, 2
    while true
        while !haskey(gapstarts, gap1)
            gap1 += 2
        end
        start1 = gapstarts[gap1]
        gap2 = gap1 + 2
        if !haskey(gapstarts, gap2)
            gap1 = gap2 + 2
            continue
        end
        start2 = gapstarts[gap2]
        if ((diff = abs(start2 - start1)) > pm)
            println("Earliest difference > $(c(pm)) between adjacent prime gap starting primes:")
            println("Gap $gap1 starts at $(c(start1)), gap $(c(gap2)) starts at $(c(start2)), difference is $(c(diff)).\n")
            pm == limit && break
            pm *= 10
        else
            gap1 = gap2
        end
    end
end

primegaps()
