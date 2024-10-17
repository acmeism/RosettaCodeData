function pcontrib{T<:Integer}(p::T, a::T)
    n = one(T)
    pcon = one(T)
    for i in 1:a
        n *= p
        pcon += n
    end
    return pcon
end

function divisorsum{T<:Integer}(n::T)
    dsum = one(T)
    for (p, a) in factor(n)
        dsum *= pcontrib(p, a)
    end
    dsum -= n
end
