struct Point{T<:AbstractFloat}
    x::T
    y::T
end
Point{T}() where T<:AbstractFloat = Point{T}(Inf, Inf)
Point() = Point{Float64}()

Base.show(io::IO, p::Point{T}) where T = iszero(p) ? print(io, "Zero{$T}") : @printf(io, "{%s}(%.3f, %.3f)", T, p.x, p.y)
Base.copy(p::Point) = Point(p.x, p.y)
Base.iszero(p::Point{T}) where T = p.x in (-Inf, Inf)
Base.:-(p::Point) = Point(p.x, -p.y)

function dbl(p::Point{T}) where T
    iszero(p) && return p

    L = 3p.x ^ 2 / 2p.y
    x = L ^ 2 - 2p.x
    y = L * (p.x - x) - p.y
    return Point{T}(x, y)
end
Base.:(==)(a::Point{T}, C::Point{T}) where T = a.x == C.x && a.y == C.y

function Base.:+(p::Point{T}, q::Point{T}) where T
    p == q && return dbl(p)
    iszero(p) && return q
    iszero(q) && return p

    L = (q.y - p.y) / (q.x - p.x)
    x = L ^ 2 - p.x - q.x
    y = L * (p.x - x) - p.y
    return Point{T}(x, y)
end
function Base.:*(p::Point, n::Integer)
    r = Point()
    i = 1
    while i ≤ n
        if i & n != 0 r += p end
        p = dbl(p)
        i <<= 1
    end
    return r
end
Base.:*(n::Integer, p::Point) = p * n

const C = 7
function Point(y::AbstractFloat)
    n = y ^ 2 - C
    x = n ≥ 0 ? n ^ (1 / 3) : -((-n) ^ (1 / 3))
    return Point{typeof(y)}(x, y)
end

a = Point(1.0)
b = Point(2.0)
@show a b
@show c = a + b
@show d = -c
@show c + d
@show a + b + d
@show 12345a
