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

    z = T(2)
    while z <= (p - 1) && p - 1 != legendre(z, p)
        z += one(z)
    end
    c::T = powermod(z, q, p)
    r::T = powermod(n, (q + 1) >> 1, p)
    t::T = powermod(n, q, p)
    m::T = s
    t2::T = zero(p)
    while !iszero((t - 1) % p)
        t2 = (t * t) % p
        i = one(T)
        while i <= m
            iszero((t2 - 1) % p) && break
            t2 = (t2 * t2) % p
            i += one(T)
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


using .TonelliShanks

@show TonelliShanks.solve(10, 13)
@show TonelliShanks.solve(56, 101)
@show TonelliShanks.solve(1030, 10009)
@show TonelliShanks.solve(44402, 100049)
@show TonelliShanks.solve(665820697, 1000000009)
@show TonelliShanks.solve(881398088036, 1000000000039)
@show TonelliShanks.solve(41660815127637347468140745042827704103445750172002, big"10" ^ 50 + 577)
