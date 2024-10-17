function patiencesort(list::Vector{T}) where T
    piles = Vector{Vector{T}}()
    for n in list
        if isempty(piles) ||
            (i = findfirst(pile -> n <= pile[end], piles)) ==  nothing
            push!(piles, [n])
        else
            push!(piles[i], n)
        end
    end
    mergesorted(piles)
end

function mergesorted(vecvec)
    lengths = map(length, vecvec)
    allsum = sum(lengths)
    sorted = similar(vecvec[1], allsum)
    for i in 1:allsum
        (val, idx) = findmin(map(x -> x[end], vecvec))
        sorted[i] = pop!(vecvec[idx])
        if isempty(vecvec[idx])
            deleteat!(vecvec, idx)
        end
    end
    sorted
end

println(patiencesort(rand(collect(1:1000), 12)))
