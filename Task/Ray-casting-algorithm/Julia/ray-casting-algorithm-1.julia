module RayCastings

export Point

struct Point{T}
    x::T
    y::T
end
Base.show(io::IO, p::Point) = print(io, "($(p.x), $(p.y))")

const Edge = Tuple{Point{T}, Point{T}} where T
Base.show(io::IO, e::Edge) = print(io, "$(e[1]) ∘-∘ $(e[2])")

function rayintersectseg(p::Point{T}, edge::Edge{T}) where T
    a, b = edge
    if a.y > b.y
        a, b = b, a
    end
    if p.y ∈ (a.y, b.y)
        p = Point(p.x, p.y + eps(p.y))
    end

    rst = false
    if (p.y > b.y || p.y < a.y) || (p.x > max(a.x, b.x))
        return false
    end

    if p.x < min(a.x, b.x)
        rst = true
    else
        mred = (b.y - a.y) / (b.x - a.x)
        mblu = (p.y - a.y) / (p.x - a.x)
        rst = mblu ≥ mred
    end

    return rst
end

isinside(poly::Vector{Tuple{Point{T}, Point{T}}}, p::Point{T}) where T =
    isodd(count(edge -> rayintersectseg(p, edge), poly))

connect(a::Point{T}, b::Point{T}...) where T =
    [(a, b) for (a, b) in zip(vcat(a, b...), vcat(b..., a))]

end  # module RayCastings
