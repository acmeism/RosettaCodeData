using Printf # required for Julia v1.x

function equalbirthdays(sharers::Int, groupsize::Int; nrep::Int = 10000)
    eq = 0
    for _ in 1:nrep
        group = rand(1:365, groupsize)
        grset = Set(group)
        if groupsize - length(grset) ≥ sharers - 1 &&
            any(count(x -> x == d, group) ≥ sharers for d in grset)
            eq += 1
        end
    end
    return eq / nrep
end

gsizes = [2]
for sh in (2, 3, 4, 5)
    local gsize = gsizes[end]
    local freq

    # Coarse
    while equalbirthdays(sh, gsize; nrep = 100) < .5
        gsize += 1
    end
    # Finer
    for gsize in trunc(Int, gsize - (gsize - gsizes[end]) / 4):(gsize + 999)
        if equalbirthdays(sh, gsize; nrep = 250) > 0.5
            break
        end
    end
    # Finest
    for gsize in (gsize - 1):(gsize + 999)
        freq = equalbirthdays(sh, gsize; nrep = 50000)
        if freq > 0.5
            break
        end
    end

    push!(gsizes, gsize)
    @printf("%i independent people in a group of %s share a common birthday. (%5.3f)\n", sh, gsize, freq)
end
