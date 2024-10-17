function divisors{T<:Integer}(n::T)
    !isprime(n) || return [one(T), n]
    d = [one(T)]
    for (k, v) in factor(n)
        e = T[k^i for i in 1:v]
        append!(d, vec([i*j for i in d, j in e]))
    end
    sort(d)
end

function vampirefangs{T<:Integer}(n::T)
    fangs = T[]
    isvampire = false
    vdcnt = ndigits(n)
    fdcnt = vdcnt>>1
    iseven(vdcnt) || return (isvampire, fangs)
    !isprime(n) || return (isvampire, fangs)
    vdigs = sort(digits(n))
    d = divisors(n)
    len = length(d)
    len = iseven(len) ? len>>1 : len>>1 + 1
    for f in d[1:len]
        ndigits(f) == fdcnt || continue
        g = div(n, f)
        f%10!=0 || g%10!=0 || continue
        sort([digits(f), digits(g)]) == vdigs || continue
        isvampire = true
        append!(fangs, [f, g])
    end
    if isvampire
        fangs = reshape(fangs, (2,length(fangs)>>1))'
    end
    return (isvampire, fangs)
end
