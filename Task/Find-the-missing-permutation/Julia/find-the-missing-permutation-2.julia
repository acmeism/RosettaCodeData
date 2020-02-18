function missingperm1(arr::Vector{<:AbstractString})
    missperm = string()
    for pos in 1:length(arr[1])
        s = Set()
        for perm in arr
            c = perm[pos]
            if c ∈ s pop!(s, c) else push!(s, c) end
        end
        missperm *= first(s)
    end
    return missperm
end
