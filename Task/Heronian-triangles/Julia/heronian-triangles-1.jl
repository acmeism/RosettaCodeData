type IntegerTriangle{T<:Integer}
    a::T
    b::T
    c::T
    p::T
    σ::T
end

function IntegerTriangle{T<:Integer}(a::T, b::T, c::T)
    p = a + b + c
    s = div(p, 2)
    σ = isqrt(s*(s-a)*(s-b)*(s-c))
    (x, y, z) = sort([a, b, c])
    IntegerTriangle(x, y, z, p, σ)
end

function isprimheronian{T<:Integer}(a::T, b::T, c::T)
    p = a + b + c
    iseven(p) || return false
    gcd(a, b, c) == 1 || return false
    s = div(p, 2)
    t = s*(s-a)*(s-b)*(s-c)
    0 < t || return false
    σ = isqrt(t)
    σ^2 == t
end
