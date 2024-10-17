function mergelist(a, b)
    out = Vector{Int}()
    while !isempty(a) && !isempty(b)
        if a[1] < b[1]
            push!(out, popfirst!(a))
        else
            push!(out, popfirst!(b))
        end
    end
    append!(out, a)
    append!(out, b)
    out
end

function strand(a)
    i, s = 1, [popfirst!(a)]
    while i < length(a) + 1
        if a[i] > s[end]
            append!(s, splice!(a, i))
        else
            i += 1
        end
    end
    s
end

strandsort(a) = (out = strand(a); while !isempty(a) out = mergelist(out, strand(a)) end; out)

println(strandsort([1, 6, 3, 2, 1, 7, 5, 3]))
