module KnuthPowerTree

const p = Dict(1 => 0)
const lvl = [[1]]

function path(n)
    global p, lvl
    iszero(n) && return Int[]
    while n ∉ keys(p)
        q = Int[]
        for x in lvl[1], y in path(x)
            if (x + y) ∉ keys(p)
                p[x + y] = x
                push!(q, x + y)
            end
        end
        lvl[1] = q
    end
    return push!(path(p[n]), n)
end

function pow(x::Number, n::Integer)
    r = Dict{typeof(n), typeof(x)}(0 => 1, 1 => x)
    p = 0
    for i in path(n)
        r[i] = r[i - p] * r[p]
        p = i
    end
    return r[n]
end

end  # module KnuthPowerTree
