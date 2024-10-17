module TonelliShanks

legendre(a, p) = powermod(a, (p - 1) ÷ 2, p)

function solve(n::T, p::T) where T <: Union{Int, Int128, BigInt}
    legendre(n, p) != 1 && throw(ArgumentError("$n not a square (mod $p)"))
    local q::T = p - one(p)
    local s::T = 0
    while iszero(q % 2)
        q ÷= 2
        s += one(s)
    end
    if s == one(s)
        r = powermod(n, (p + 1) >> 2, p)
        return r, p - r
    end
    local z::T
    for z in 2:(p - 1)
        p - 1 == legendre(z, p) && break
    end
    local c::T = powermod(z, q, p)
    local r::T = powermod(n, (q + 1) >> 1, p)
    local t::T = powermod(n, q, p)
    local m::T = s
    local t2::T = zero(p)
    while !iszero((t - 1) % p)
        t2 = (t * t) % p
        local i::T
        for i in Base.OneTo(m)
            iszero((t2 - 1) % p) && break
            t2 = (t2 * t2) % p
        end
        b = powermod(c, 1 << (m - i - 1), p)
        r = (r * b) % p
        c = (b * b) % p
        t = (t * c) % p
        m = i
    end
    return r, p - r
end

end  # module TonelliShanks
