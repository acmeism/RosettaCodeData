using Printf
import Base.in

struct EllipticCurve{T <: AbstractFloat}
    a::T
    b::T
    EllipticCurve(a::T, b::T) where T <: AbstractFloat = new{T}(a, b)
end

in(c::EllipticCurve, x, y) = (x == Inf || y == Inf || y^2 ≈ x^3 + c.a * x + c.b)

const Curve07 = EllipticCurve(0.0, 7.0)

struct EPoint{T <: AbstractFloat}
    x::T
    y::T
    curve::EllipticCurve
end
EPoint{T}() where T <: AbstractFloat = EPoint{T}(Inf, Inf, Curve07)
EPoint() = EPoint{Float64}()
function EPoint(x, y, c::EllipticCurve=Curve07)
    @assert in(c, x, y)
    EPoint(x, y, c)
end

Base.show(io::IO, p::EPoint{T}) where T = iszero(p) ? print(io, "Zero{$T}") : @printf(io, "{%s}(%.3f, %.3f)", T, p.x, p.y)
Base.copy(p::EPoint) = EPoint(p.x, p.y, p.curve)
Base.iszero(p::EPoint{T}) where T = p.x in (-Inf, Inf, p.curve)
Base.:-(p::EPoint) = EPoint(p.x, -p.y, p.curve)

function dbl(p::EPoint{T}) where T
    iszero(p) && return p

    L = 3p.x ^ 2 / 2p.y
    x = L ^ 2 - 2p.x
    y = L * (p.x - x) - p.y
    return EPoint{T}(x, y, p.curve)
end

function Base.:(==)(a::EPoint{T}, C::EPoint{T}) where T
    @assert a.curve == C.curve
    return (iszero(a) && iszero(C)) || (a.x == C.x && a.y == C.y)
end

function Base.:+(p::EPoint{T}, q::EPoint{T}) where T
    @assert p.curve == q.curve
    p == q && return dbl(p)
    iszero(p) && return q
    iszero(q) && return p

    L = (q.y - p.y) / (q.x - p.x)
    x = L ^ 2 - p.x - q.x
    y = L * (p.x - x) - p.y
    return EPoint{T}(x, y, p.curve)
end

function Base.:*(p::EPoint, n::Integer)
    r = EPoint()
    i = 1
    while i ≤ n
        if i & n != 0 r += p end
        p = dbl(p)
        i <<= 1
    end
    return r
end
Base.:*(n::Integer, p::EPoint) = p * n

const C = 7.0

function EPoint(y::AbstractFloat)
    n = y ^ 2 - C
    x = n ≥ 0 ? n ^ (1 / 3) : -((-n) ^ (1 / 3))
    return EPoint{typeof(y)}(x, y, Curve07)
end

a = EPoint(1.0)
b = EPoint(2.0)
@show a b
@show c = a + b
@show d = -c
@show c + d
@show a + b + d
@show 12345a
