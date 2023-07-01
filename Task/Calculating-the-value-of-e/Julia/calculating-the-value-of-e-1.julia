module NeperConstant

export NeperConst

struct NeperConst{T}
    val::T
end

Base.show(io::IO, nc::NeperConst{T}) where T = print(io, "ℯ (", T, ") = ", nc.val)

function NeperConst{T}() where T
    local e::T  = 2.0
    local e2::T = 1.0
    local den::(T ≡ BigFloat ? BigInt : Int128) = 1
    local n::typeof(den) = 2
    while e ≠ e2
        e2 = e
        den *= n
        n += one(n)
        e += 1.0 / den
    end
    return NeperConst{T}(e)
end

end  # module NeperConstant
