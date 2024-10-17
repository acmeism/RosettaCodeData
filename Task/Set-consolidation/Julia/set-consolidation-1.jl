function consolidate{T}(a::Array{Set{T},1})
    1 < length(a) || return a
    b = copy(a)
    c = Set{T}[]
    while 1 < length(b)
        x = shift!(b)
        cme = true
        for (i, y) in enumerate(b)
            !isempty(intersect(x, y)) || continue
            cme = false
            b[i] = union(x, y)
            break
        end
        !cme || push!(c, x)
    end
    push!(c, b[1])
    return c
end
