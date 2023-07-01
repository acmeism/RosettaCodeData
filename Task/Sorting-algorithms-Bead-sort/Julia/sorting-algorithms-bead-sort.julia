function beadsort(a::Vector{<:Integer})
    lo, hi = extrema(a)
    if lo < 1 throw(DomainError()) end
    len = length(a)
    abacus = falses(len, hi)
    for (i, v) in enumerate(a)
       abacus[i, 1:v] = true
    end
    for i in 1:hi
        v = sum(abacus[:, i])
        if v < len
            abacus[1:end-v, i] = false
            abacus[end-v+1:end, i] = true
        end
    end
    return collect(eltype(a), sum(abacus[i,:]) for i in 1:len)
end

v = rand(UInt8, 20)
println("# unsorted bytes: $v\n -> sorted bytes: $(beadsort(v))")
v = rand(1:2 ^ 10, 20)
println("# unsorted integers: $v\n -> sorted integers: $(beadsort(v))")
