function levendist1(s::AbstractString, t::AbstractString)
    ls, lt = length(s), length(t)
    if ls > lt
        s, t = t, s
        ls, lt = lt, ls
    end
    dist = collect(0:ls)
    for (ind2, chr2) in enumerate(t)
        newdist = Vector{Int}(ls+1)
        newdist[1] = ind2
        for (ind1, chr1) in enumerate(s)
            if chr1 == chr2
                newdist[ind1+1] = dist[ind1]
            else
                newdist[ind1+1] = 1 + min(dist[ind1], dist[ind1+1], newdist[end])
            end
        end
        dist = newdist
    end
    return dist[end]
end
